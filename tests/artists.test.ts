import crypto from 'crypto';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../src/api/index';
import { pool } from '../src/db/client';
import { hashKey } from '../src/api/middleware/auth';

let apiKey: string;
let createdId: string;

beforeAll(async () => {
  const raw = 'disc_' + crypto.randomBytes(16).toString('hex');
  apiKey = raw;
  await pool.query(
    'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2)',
    ['test-artists', hashKey(raw)]
  );
});

afterAll(async () => {
  await pool.query("DELETE FROM api_keys WHERE label = 'test-artists'");
});

describe('Artist CRUD', () => {
  it('creates an artist', async () => {
    const res = await request(app)
      .post('/api/v1/artists')
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ name: 'Test Artist', sort_name: 'Artist, Test', aliases: ['TA', 'The Artist'] });
    expect(res.status).toBe(201);
    expect(res.body.name).toBe('Test Artist');
    expect(res.body.aliases).toContain('TA');
    createdId = res.body.id;
  });

  it('reads the created artist', async () => {
    const res = await request(app).get(`/api/v1/artists/${createdId}`);
    expect(res.status).toBe(200);
    expect(res.body.id).toBe(createdId);
    expect(res.body.sort_name).toBe('Artist, Test');
  });

  it('lists artists and includes the created one', async () => {
    const res = await request(app).get('/api/v1/artists');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.some((a: { id: string }) => a.id === createdId)).toBe(true);
  });

  it('updates the artist', async () => {
    const res = await request(app)
      .patch(`/api/v1/artists/${createdId}`)
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ sort_name: 'Updated Name' });
    expect(res.status).toBe(200);
    expect(res.body.sort_name).toBe('Updated Name');
  });

  it('returns 404 for a non-existent artist', async () => {
    const res = await request(app).get('/api/v1/artists/00000000-0000-0000-0000-000000000000');
    expect(res.status).toBe(404);
  });

  it('deletes the artist', async () => {
    const res = await request(app)
      .delete(`/api/v1/artists/${createdId}`)
      .set('Authorization', `Bearer ${apiKey}`);
    expect(res.status).toBe(204);
  });

  it('returns 404 after deletion', async () => {
    const res = await request(app).get(`/api/v1/artists/${createdId}`);
    expect(res.status).toBe(404);
  });
});
