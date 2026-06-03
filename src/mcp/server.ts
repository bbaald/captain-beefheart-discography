import { McpServer } from '@modelcontextprotocol/sdk/server/mcp.js';
import { z } from 'zod/v3';
import { pool } from '../db/client';

/**
 * Factory function — creates and returns a fully configured McpServer instance.
 * One server instance is created per client session to avoid shared-state issues.
 */
export function createMcpServer(): McpServer {
  const server = new McpServer({ name: 'discography', version: '1.0.0' });

  server.registerTool('search_songs',    { description: searchSongsDesc,    inputSchema: searchSongsSchema },    searchSongs);
  server.registerTool('get_song',        { description: getSongDesc,        inputSchema: getSongSchema },        getSong);
  server.registerTool('list_albums',     { description: listAlbumsDesc,     inputSchema: listAlbumsSchema },     listAlbums);
  server.registerTool('get_album',       { description: getAlbumDesc,       inputSchema: getAlbumSchema },       getAlbum);
  server.registerTool('get_artist',      { description: getArtistDesc },                                        () => getArtist());
  server.registerTool('list_personnel',  { description: listPersonnelDesc,  inputSchema: listPersonnelSchema },  listPersonnel);

  return server;
}

// ─── Shared result type ───────────────────────────────────────────────────────

export interface McpTextResult {
  // Index signature required to satisfy SDK's CallToolResult type
  [key: string]: unknown;
  isError?: true;
  content: Array<{ type: 'text'; text: string }>;
}

function ok(data: unknown): McpTextResult {
  return { content: [{ type: 'text' as const, text: JSON.stringify(data) }] };
}

function notFound(msg: string): McpTextResult {
  return { isError: true, content: [{ type: 'text' as const, text: msg }] };
}

// ─── 1. search_songs ─────────────────────────────────────────────────────────

const searchSongsDesc =
  'Search songs by title or lyrics. Optionally filter by media type, recording type, or release year. ' +
  'Returns up to 50 song summaries ordered by release year (newest first), then title.';

const searchSongsSchema = {
  query: z.string().describe('Search string matched against title and lyrics (case-insensitive partial match)'),
  media_type: z.enum(['audio', 'video']).optional().describe('Filter by media type'),
  recording_type: z.enum(['studio', 'live']).optional().describe('Filter by recording type'),
  year: z.number().int().optional().describe('Filter by release year'),
};

export async function searchSongs(args: {
  query: string;
  media_type?: 'audio' | 'video';
  recording_type?: 'studio' | 'live';
  year?: number;
}): Promise<McpTextResult> {
  const conditions: string[] = ['(title ILIKE $1 OR lyrics ILIKE $1)'];
  const params: unknown[] = [`%${args.query}%`];

  if (args.media_type) {
    params.push(args.media_type);
    conditions.push(`media_type = $${params.length}`);
  }
  if (args.recording_type) {
    params.push(args.recording_type);
    conditions.push(`recording_type = $${params.length}`);
  }
  if (args.year !== undefined) {
    params.push(args.year);
    conditions.push(`release_year = $${params.length}`);
  }

  const { rows } = await pool.query(
    `SELECT id, title, credited_as, media_type, recording_type,
            running_time_seconds, release_year,
            CASE WHEN title ILIKE $1 THEN NULL
                 ELSE left(lyrics, 120)
            END AS lyrics_snippet
     FROM songs
     WHERE ${conditions.join(' AND ')}
     ORDER BY release_year DESC NULLS LAST, title
     LIMIT 50`,
    params,
  );

  return ok(rows);
}

// ─── 2. get_song ──────────────────────────────────────────────────────────────

const getSongDesc =
  'Get a full song record including the albums it appears on and all personnel credits.';

const getSongSchema = {
  id: z.string().uuid().describe('Song UUID'),
};

export async function getSong(args: { id: string }): Promise<McpTextResult> {
  const [songResult, albumsResult, personnelResult] = await Promise.all([
    pool.query(`SELECT * FROM songs WHERE id = $1`, [args.id]),
    pool.query(
      `SELECT a.id, a.title, a.credited_as, a.album_type, a.release_year,
              a.cover_art_url, sa.sequence_number
       FROM song_albums sa
       JOIN albums a ON a.id = sa.album_id
       WHERE sa.song_id = $1
       ORDER BY a.release_year DESC NULLS LAST, a.title`,
      [args.id],
    ),
    pool.query(
      `SELECT p.id, p.name, p.sort_name, sp.role, sp.instrument
       FROM song_personnel sp
       JOIN personnel p ON p.id = sp.personnel_id
       WHERE sp.song_id = $1
       ORDER BY sp.role, p.name`,
      [args.id],
    ),
  ]);

  if (songResult.rows.length === 0) {
    return notFound(`Song not found: ${args.id}`);
  }

  return ok({
    ...songResult.rows[0],
    albums: albumsResult.rows,
    personnel: personnelResult.rows,
  });
}

// ─── 3. list_albums ──────────────────────────────────────────────────────────

const listAlbumsDesc =
  'List albums with optional filtering by type and year. ' +
  'Returns up to 50 album summaries ordered by release year (newest first), then title.';

const listAlbumsSchema = {
  album_type: z
    .enum(['LP', 'EP', 'Single', 'Compilation', 'Live'])
    .optional()
    .describe('Filter by album type'),
  year: z.number().int().optional().describe('Filter by release year'),
  sort: z
    .enum(['release_year', 'title'])
    .optional()
    .describe('Sort field — release_year (default, newest first) or title (A–Z)'),
  limit: z.number().int().min(1).max(100).optional().describe('Max results (default 50)'),
  offset: z.number().int().min(0).optional().describe('Pagination offset (default 0)'),
};

export async function listAlbums(args: {
  album_type?: 'LP' | 'EP' | 'Single' | 'Compilation' | 'Live';
  year?: number;
  sort?: 'release_year' | 'title';
  limit?: number;
  offset?: number;
}): Promise<McpTextResult> {
  const conditions: string[] = [];
  const params: unknown[] = [];

  if (args.album_type) {
    params.push(args.album_type);
    conditions.push(`album_type = $${params.length}`);
  }
  if (args.year !== undefined) {
    params.push(args.year);
    conditions.push(`release_year = $${params.length}`);
  }

  const where = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
  const orderBy = args.sort === 'title' ? 'title' : 'release_year DESC NULLS LAST, title';
  const limit = args.limit ?? 50;
  const offset = args.offset ?? 0;

  params.push(limit, offset);
  const limitIdx = params.length - 1;
  const offsetIdx = params.length;

  const { rows } = await pool.query(
    `SELECT id, title, credited_as, album_type, release_year, cover_art_url
     FROM albums
     ${where}
     ORDER BY ${orderBy}
     LIMIT $${limitIdx} OFFSET $${offsetIdx}`,
    params,
  );

  return ok(rows);
}

// ─── 4. get_album ─────────────────────────────────────────────────────────────

const getAlbumDesc = 'Get an album record with its ordered tracklist.';

const getAlbumSchema = {
  id: z.string().uuid().describe('Album UUID'),
};

export async function getAlbum(args: { id: string }): Promise<McpTextResult> {
  const [albumResult, tracklistResult] = await Promise.all([
    pool.query(`SELECT * FROM albums WHERE id = $1`, [args.id]),
    pool.query(
      `SELECT s.id, s.title, s.credited_as, s.media_type, s.recording_type,
              s.running_time_seconds, s.release_year, sa.sequence_number
       FROM song_albums sa
       JOIN songs s ON s.id = sa.song_id
       WHERE sa.album_id = $1
       ORDER BY sa.sequence_number`,
      [args.id],
    ),
  ]);

  if (albumResult.rows.length === 0) {
    return notFound(`Album not found: ${args.id}`);
  }

  return ok({
    ...albumResult.rows[0],
    tracklist: tracklistResult.rows,
  });
}

// ─── 5. get_artist ────────────────────────────────────────────────────────────

const getArtistDesc =
  'Get the canonical artist record with their name, bio, and all performing aliases. ' +
  'Returns the first (and typically only) artist in the database.';

export async function getArtist(): Promise<McpTextResult> {
  const { rows } = await pool.query(
    `SELECT * FROM artists ORDER BY created_at LIMIT 1`,
  );

  if (rows.length === 0) {
    return notFound('No artist found in database');
  }

  return ok(rows[0]);
}

// ─── 6. list_personnel ───────────────────────────────────────────────────────

const listPersonnelDesc =
  'Get all personnel credited on a specific song, including their role and instrument.';

const listPersonnelSchema = {
  song_id: z.string().uuid().describe('Song UUID'),
};

export async function listPersonnel(args: { song_id: string }): Promise<McpTextResult> {
  const { rows } = await pool.query(
    `SELECT p.id, p.name, p.sort_name, sp.role, sp.instrument
     FROM song_personnel sp
     JOIN personnel p ON p.id = sp.personnel_id
     WHERE sp.song_id = $1
     ORDER BY sp.role, p.name`,
    [args.song_id],
  );

  return ok(rows);
}
