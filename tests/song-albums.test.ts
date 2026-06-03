import crypto from 'crypto';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../src/api/index';
import { pool } from '../src/db/client';
import { hashKey } from '../src/api/middleware/auth';

let apiKey: string;
let artistId: string;
let songId: string;
let albumId: string;

beforeAll(async () => {
  const raw = 'disc_' + crypto.randomBytes(16).toString('hex');
  apiKey = raw;
  await pool.query('INSERT INTO api_keys (label, key_hash) VALUES ($1, $2)', ['test-song-albums', hashKey(raw)]);

  const { rows: [artist] } = await pool.query<{ id: string }>(
    "INSERT INTO artists (name) VALUES ('SA Test Artist') RETURNING id"
  );
  artistId = artist.id;

  const { rows: [song] } = await pool.query<{ id: string }>(
    `INSERT INTO songs (title, artist_id, media_type, running_time_seconds, release_year, source_list)
     VALUES ('SA Test Song', $1, 'audio', 200, 2000, '{"test"}') RETURNING id`,
    [artistId]
  );
  songId = song.id;

  const { rows: [album] } = await pool.query<{ id: string }>(
    "INSERT INTO albums (artist_id, title, release_year) VALUES ($1, 'SA Test Album', 2000) RETURNING id",
    [artistId]
  );
  albumId = album.id;
});

afterAll(async () => {
  await pool.query('DELETE FROM song_albums WHERE song_id = $1', [songId]);
  await pool.query('DELETE FROM songs   WHERE id = $1', [songId]);
  await pool.query('DELETE FROM albums  WHERE id = $1', [albumId]);
  await pool.query('DELETE FROM artists WHERE id = $1', [artistId]);
  await pool.query("DELETE FROM api_keys WHERE label = 'test-song-albums'");
});

describe('Song–Album relationships', () => {
  it('adds a song to an album', async () => {
    const res = await request(app)
      .post(`/api/v1/songs/${songId}/albums`)
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ album_id: albumId, sequence_number: 1 });
    expect(res.status).toBe(201);
    expect(res.body.sequence_number).toBe(1);
  });

  it('GET /songs/:id includes the album', async () => {
    const res = await request(app).get(`/api/v1/songs/${songId}`);
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body.albums)).toBe(true);
    expect(res.body.albums).toHaveLength(1);
    expect(res.body.albums[0].id).toBe(albumId);
  });

  it('GET /albums/:id includes the song', async () => {
    const res = await request(app).get(`/api/v1/albums/${albumId}`);
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body.songs)).toBe(true);
    expect(res.body.songs).toHaveLength(1);
    expect(res.body.songs[0].sequence_number).toBe(1);
  });

  it('returns 409 when adding the same song to the same album again', async () => {
    const res = await request(app)
      .post(`/api/v1/songs/${songId}/albums`)
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ album_id: albumId, sequence_number: 2 });
    expect(res.status).toBe(409);
  });

  it('returns 409 when sequence_number is already taken on that album', async () => {
    // Create a second song to conflict on track 1
    const { rows: [song2] } = await pool.query<{ id: string }>(
      `INSERT INTO songs (title, artist_id, media_type, running_time_seconds, release_year, source_list)
       VALUES ('SA Test Song 2', $1, 'audio', 180, 2000, '{"test"}') RETURNING id`,
      [artistId]
    );
    const res = await request(app)
      .post(`/api/v1/songs/${song2.id}/albums`)
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ album_id: albumId, sequence_number: 1 });
    expect(res.status).toBe(409);
    expect(res.body.error).toMatch(/track number/i);
    await pool.query('DELETE FROM songs WHERE id = $1', [song2.id]);
  });

  it('removes the song from the album', async () => {
    const res = await request(app)
      .delete(`/api/v1/songs/${songId}/albums/${albumId}`)
      .set('Authorization', `Bearer ${apiKey}`);
    expect(res.status).toBe(204);
  });

  it('returns 404 removing a relationship that does not exist', async () => {
    const res = await request(app)
      .delete(`/api/v1/songs/${songId}/albums/${albumId}`)
      .set('Authorization', `Bearer ${apiKey}`);
    expect(res.status).toBe(404);
  });
});
