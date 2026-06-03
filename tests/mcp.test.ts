/**
 * tests/mcp.test.ts
 *
 * Integration tests for all six MCP tool handlers.
 * Handlers are called directly (no HTTP round-trip) against the live database.
 *
 * Fixtures are resolved from the seeded Captain Beefheart data in beforeAll;
 * no UUIDs are hardcoded.
 */

import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import { pool } from '../src/db/client';
import {
  searchSongs,
  getSong,
  listAlbums,
  getAlbum,
  getArtist,
  listPersonnel,
  type McpTextResult,
} from '../src/mcp/server';

// ─── Fixtures ─────────────────────────────────────────────────────────────────

let knownSongId: string;         // "Electricity" — on Safe As Milk, has personnel
let knownSongTitle: string;
let knownAlbumId: string;        // "Safe As Milk" — 12 tracks, LP
let knownLiveAlbumId: string;    // first Live album
let personnelSongId: string;     // a song known to have personnel

const MISSING_UUID = '00000000-0000-0000-0000-000000000000';

beforeAll(async () => {
  const songRow = await pool.query<{ id: string; title: string }>(
    `SELECT id, title FROM songs WHERE title ILIKE 'Electricity' LIMIT 1`,
  );
  knownSongId = songRow.rows[0].id;
  knownSongTitle = songRow.rows[0].title;

  const albumRow = await pool.query<{ id: string }>(
    `SELECT id FROM albums WHERE LOWER(title) = 'safe as milk' LIMIT 1`,
  );
  knownAlbumId = albumRow.rows[0].id;

  const liveRow = await pool.query<{ id: string }>(
    `SELECT id FROM albums WHERE album_type = 'Live' LIMIT 1`,
  );
  knownLiveAlbumId = liveRow.rows[0].id;

  // Pick a song that has at least one personnel credit
  const credRow = await pool.query<{ song_id: string }>(
    `SELECT song_id FROM song_personnel LIMIT 1`,
  );
  personnelSongId = credRow.rows[0].song_id;
});

afterAll(async () => {
  await pool.end();
});

// ─── Shape helpers ────────────────────────────────────────────────────────────

function parseResult(result: McpTextResult) {
  expect(result.content).toBeDefined();
  expect(result.content.length).toBeGreaterThan(0);
  expect(result.content[0].type).toBe('text');
  return JSON.parse(result.content[0].text);
}

// ─── search_songs ─────────────────────────────────────────────────────────────

describe('search_songs', () => {
  it('returns songs matching a known title', async () => {
    const result = await searchSongs({ query: 'Electricity' });
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBeGreaterThan(0);
    expect(data[0].title).toMatch(/electricity/i);
  });

  it('returns an empty array for a nonsense query', async () => {
    const result = await searchSongs({ query: 'xyzzy_no_such_song_99999' });
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBe(0);
  });

  it('returns objects with expected shape', async () => {
    const result = await searchSongs({ query: 'Electricity' });
    const data = parseResult(result);
    const song = data[0];
    expect(song).toHaveProperty('id');
    expect(song).toHaveProperty('title');
    expect(song).toHaveProperty('media_type');
    expect(song).toHaveProperty('recording_type');
    expect(song).toHaveProperty('release_year');
  });

  it('filters by recording_type=studio', async () => {
    const result = await searchSongs({ query: '', recording_type: 'studio' });
    const data = parseResult(result);
    expect(data.length).toBeGreaterThan(0);
    data.forEach((s: { recording_type: string }) =>
      expect(s.recording_type).toBe('studio'),
    );
  });

  it('filters by recording_type=live', async () => {
    const result = await searchSongs({ query: '', recording_type: 'live' });
    const data = parseResult(result);
    expect(data.length).toBeGreaterThan(0);
    data.forEach((s: { recording_type: string }) =>
      expect(s.recording_type).toBe('live'),
    );
  });

  it('filters by year', async () => {
    const result = await searchSongs({ query: '', year: 1967 });
    const data = parseResult(result);
    expect(data.length).toBeGreaterThan(0);
    data.forEach((s: { release_year: number }) =>
      expect(s.release_year).toBe(1967),
    );
  });

  it('does not return isError for an empty result', async () => {
    const result = await searchSongs({ query: 'xyzzy_no_such_song_99999' });
    expect(result.isError).toBeUndefined();
  });
});

// ─── get_song ─────────────────────────────────────────────────────────────────

describe('get_song', () => {
  it('returns the full song with albums and personnel', async () => {
    const result = await getSong({ id: knownSongId });
    const data = parseResult(result);
    expect(data.id).toBe(knownSongId);
    expect(data.title).toMatch(/electricity/i);
    expect(Array.isArray(data.albums)).toBe(true);
    expect(Array.isArray(data.personnel)).toBe(true);
    expect(data.albums.length).toBeGreaterThan(0);
  });

  it('albums array contains expected fields', async () => {
    const result = await getSong({ id: knownSongId });
    const data = parseResult(result);
    const album = data.albums[0];
    expect(album).toHaveProperty('id');
    expect(album).toHaveProperty('title');
    expect(album).toHaveProperty('sequence_number');
  });

  it('returns isError for an unknown UUID', async () => {
    const result = await getSong({ id: MISSING_UUID });
    expect(result.isError).toBe(true);
    expect(result.content[0].text).toMatch(MISSING_UUID);
  });
});

// ─── list_albums ──────────────────────────────────────────────────────────────

describe('list_albums', () => {
  it('returns all albums (≥ 19)', async () => {
    const result = await listAlbums({});
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBeGreaterThanOrEqual(19);
  });

  it('returns objects with expected shape', async () => {
    const result = await listAlbums({});
    const data = parseResult(result);
    const album = data[0];
    expect(album).toHaveProperty('id');
    expect(album).toHaveProperty('title');
    expect(album).toHaveProperty('album_type');
    expect(album).toHaveProperty('release_year');
  });

  it('filters to only LPs', async () => {
    const result = await listAlbums({ album_type: 'LP' });
    const data = parseResult(result);
    expect(data.length).toBeGreaterThanOrEqual(14);
    data.forEach((a: { album_type: string }) =>
      expect(a.album_type).toBe('LP'),
    );
  });

  it('filters to only Live albums', async () => {
    const result = await listAlbums({ album_type: 'Live' });
    const data = parseResult(result);
    expect(data.length).toBeGreaterThanOrEqual(5);
    data.forEach((a: { album_type: string }) =>
      expect(a.album_type).toBe('Live'),
    );
  });

  it('respects limit', async () => {
    const result = await listAlbums({ limit: 3 });
    const data = parseResult(result);
    expect(data.length).toBeLessThanOrEqual(3);
  });

  it('sorts by title when sort=title', async () => {
    const result = await listAlbums({ sort: 'title', limit: 5 });
    const data = parseResult(result);
    const titles: string[] = data.map((a: { title: string }) => a.title.toLowerCase());
    const sorted = [...titles].sort();
    expect(titles).toEqual(sorted);
  });
});

// ─── get_album ────────────────────────────────────────────────────────────────

describe('get_album', () => {
  it('returns album with ordered tracklist', async () => {
    const result = await getAlbum({ id: knownAlbumId });
    const data = parseResult(result);
    expect(data.id).toBe(knownAlbumId);
    expect(data.title).toMatch(/safe as milk/i);
    expect(Array.isArray(data.tracklist)).toBe(true);
    expect(data.tracklist.length).toBe(12);
  });

  it('tracklist is ordered by sequence_number', async () => {
    const result = await getAlbum({ id: knownAlbumId });
    const data = parseResult(result);
    const seqs: number[] = data.tracklist.map((t: { sequence_number: number }) => t.sequence_number);
    for (let i = 1; i < seqs.length; i++) {
      expect(seqs[i]).toBeGreaterThan(seqs[i - 1]);
    }
  });

  it('tracklist items have expected shape', async () => {
    const result = await getAlbum({ id: knownAlbumId });
    const data = parseResult(result);
    const track = data.tracklist[0];
    expect(track).toHaveProperty('id');
    expect(track).toHaveProperty('title');
    expect(track).toHaveProperty('sequence_number');
    expect(track.sequence_number).toBe(1);
  });

  it('returns isError for an unknown UUID', async () => {
    const result = await getAlbum({ id: MISSING_UUID });
    expect(result.isError).toBe(true);
    expect(result.content[0].text).toMatch(MISSING_UUID);
  });

  it('live albums also return a tracklist', async () => {
    const result = await getAlbum({ id: knownLiveAlbumId });
    const data = parseResult(result);
    expect(Array.isArray(data.tracklist)).toBe(true);
    expect(data.tracklist.length).toBeGreaterThan(0);
  });
});

// ─── get_artist ───────────────────────────────────────────────────────────────

describe('get_artist', () => {
  it('returns the Captain Beefheart artist record', async () => {
    const result = await getArtist();
    const data = parseResult(result);
    expect(data).toHaveProperty('id');
    expect(data.name).toBe('Captain Beefheart');
  });

  it('aliases include Don Van Vliet', async () => {
    const result = await getArtist();
    const data = parseResult(result);
    expect(Array.isArray(data.aliases)).toBe(true);
    expect(data.aliases).toContain('Don Van Vliet');
  });

  it('does not return isError', async () => {
    const result = await getArtist();
    expect(result.isError).toBeUndefined();
  });
});

// ─── list_personnel ───────────────────────────────────────────────────────────

describe('list_personnel', () => {
  it('returns personnel for a song that has credits', async () => {
    const result = await listPersonnel({ song_id: personnelSongId });
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBeGreaterThan(0);
  });

  it('personnel items have expected shape', async () => {
    const result = await listPersonnel({ song_id: personnelSongId });
    const data = parseResult(result);
    const person = data[0];
    expect(person).toHaveProperty('id');
    expect(person).toHaveProperty('name');
    expect(person).toHaveProperty('sort_name');
    expect(person).toHaveProperty('role');
  });

  it('returns an empty array for a song with no credits', async () => {
    // Find a song without any personnel credits
    const { rows } = await pool.query<{ id: string }>(
      `SELECT s.id FROM songs s
       LEFT JOIN song_personnel sp ON sp.song_id = s.id
       WHERE sp.song_id IS NULL
       LIMIT 1`,
    );
    const songWithNoCredits = rows[0]?.id;
    if (!songWithNoCredits) return; // skip if all songs have credits

    const result = await listPersonnel({ song_id: songWithNoCredits });
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBe(0);
  });

  it('does not return isError for an unknown song UUID', async () => {
    // list_personnel returns empty array — not an error — for unknown IDs
    const result = await listPersonnel({ song_id: MISSING_UUID });
    expect(result.isError).toBeUndefined();
    const data = parseResult(result);
    expect(Array.isArray(data)).toBe(true);
    expect(data.length).toBe(0);
  });

  it('Electricity has Don Van Vliet in its personnel', async () => {
    const result = await listPersonnel({ song_id: knownSongId });
    const data = parseResult(result);
    const names: string[] = data.map((p: { name: string }) => p.name);
    expect(names).toContain('Don Van Vliet');
  });
});
