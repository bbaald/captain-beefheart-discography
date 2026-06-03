import crypto from 'crypto';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../src/api/index';
import { pool } from '../src/db/client';
import { hashKey } from '../src/api/middleware/auth';

let apiKey: string;
let artistId: string;

const validSong = () => ({
  title: 'Test Song',
  artist_id: artistId,
  media_type: 'audio',
  running_time_seconds: 210,
  release_year: 2020,
  source_list: ['liner notes, 2020 pressing'],
});

beforeAll(async () => {
  const raw = 'disc_' + crypto.randomBytes(16).toString('hex');
  apiKey = raw;
  await pool.query(
    'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2)',
    ['test-songs', hashKey(raw)]
  );
  const { rows } = await pool.query<{ id: string }>(
    "INSERT INTO artists (name) VALUES ('Song Test Artist') RETURNING id"
  );
  artistId = rows[0].id;
});

afterAll(async () => {
  await pool.query('DELETE FROM songs WHERE artist_id = $1', [artistId]);
  await pool.query('DELETE FROM artists WHERE id = $1', [artistId]);
  await pool.query("DELETE FROM api_keys WHERE label = 'test-songs'");
});

describe('Song Priority 1 validation', () => {
  it('creates a song with all required fields', async () => {
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send(validSong());
    expect(res.status).toBe(201);
    expect(res.body.title).toBe('Test Song');
    expect(res.body.media_type).toBe('audio');
  });

  it('rejects missing title', async () => {
    const { title: _, ...body } = validSong();
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send(body);
    expect(res.status).toBe(422);
  });

  it('rejects missing media_type', async () => {
    const { media_type: _, ...body } = validSong();
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send(body);
    expect(res.status).toBe(422);
  });

  it('rejects invalid media_type', async () => {
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ ...validSong(), media_type: 'podcast' });
    expect(res.status).toBe(422);
  });

  it('rejects missing running_time_seconds', async () => {
    const { running_time_seconds: _, ...body } = validSong();
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send(body);
    expect(res.status).toBe(422);
  });

  it('rejects missing release_year', async () => {
    const { release_year: _, ...body } = validSong();
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send(body);
    expect(res.status).toBe(422);
  });

  it('rejects an empty source_list', async () => {
    const res = await request(app)
      .post('/api/v1/songs')
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ ...validSong(), source_list: [] });
    expect(res.status).toBe(422);
  });
});
