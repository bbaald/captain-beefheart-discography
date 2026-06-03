import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../src/api/index';
import { pool } from '../src/db/client';

let artistId: string;
let songId: string;
let albumId: string;

const UNIQUE = 'zxqsearch' + Date.now();

beforeAll(async () => {
  const { rows: [artist] } = await pool.query<{ id: string }>(
    "INSERT INTO artists (name) VALUES ('Search Test Artist') RETURNING id"
  );
  artistId = artist.id;

  const { rows: [song] } = await pool.query<{ id: string }>(
    `INSERT INTO songs (title, artist_id, media_type, running_time_seconds, release_year, source_list)
     VALUES ($1, $2, 'audio', 200, 2001, '{"test"}') RETURNING id`,
    [`${UNIQUE} Song`, artistId]
  );
  songId = song.id;

  const { rows: [album] } = await pool.query<{ id: string }>(
    'INSERT INTO albums (artist_id, title, release_year) VALUES ($1, $2, 2001) RETURNING id',
    [artistId, `${UNIQUE} Album`]
  );
  albumId = album.id;
});

afterAll(async () => {
  await pool.query('DELETE FROM songs   WHERE id = $1', [songId]);
  await pool.query('DELETE FROM albums  WHERE id = $1', [albumId]);
  await pool.query('DELETE FROM artists WHERE id = $1', [artistId]);
});

describe('Search', () => {
  it('returns matching songs and albums', async () => {
    const res = await request(app).get(`/api/v1/search?q=${UNIQUE}`);
    expect(res.status).toBe(200);
    expect(res.body.query).toBe(UNIQUE);
    expect(res.body.results.songs.some((s: { id: string }) => s.id === songId)).toBe(true);
    expect(res.body.results.albums.some((a: { id: string }) => a.id === albumId)).toBe(true);
  });

  it('filters to songs only with type=song', async () => {
    const res = await request(app).get(`/api/v1/search?q=${UNIQUE}&type=song`);
    expect(res.status).toBe(200);
    expect(res.body.results.songs.some((s: { id: string }) => s.id === songId)).toBe(true);
    expect(res.body.results.albums).toHaveLength(0);
  });

  it('filters to albums only with type=album', async () => {
    const res = await request(app).get(`/api/v1/search?q=${UNIQUE}&type=album`);
    expect(res.status).toBe(200);
    expect(res.body.results.albums.some((a: { id: string }) => a.id === albumId)).toBe(true);
    expect(res.body.results.songs).toHaveLength(0);
  });

  it('is case-insensitive', async () => {
    const res = await request(app).get(`/api/v1/search?q=${UNIQUE.toUpperCase()}`);
    expect(res.status).toBe(200);
    expect(res.body.results.songs.some((s: { id: string }) => s.id === songId)).toBe(true);
  });

  it('returns 400 when q is missing', async () => {
    const res = await request(app).get('/api/v1/search');
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('MISSING_QUERY');
  });

  it('returns 400 for an invalid type', async () => {
    const res = await request(app).get('/api/v1/search?q=foo&type=person');
    expect(res.status).toBe(400);
    expect(res.body.code).toBe('INVALID_TYPE');
  });
});
