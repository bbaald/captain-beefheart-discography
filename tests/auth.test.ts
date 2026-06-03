import crypto from 'crypto';
import { describe, it, expect, beforeAll, afterAll } from 'vitest';
import request from 'supertest';
import app from '../src/api/index';
import { pool } from '../src/db/client';
import { hashKey } from '../src/api/middleware/auth';

let validKey: string;
let revokedKey: string;

beforeAll(async () => {
  const raw1 = 'disc_' + crypto.randomBytes(16).toString('hex');
  validKey = raw1;
  await pool.query(
    'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2)',
    ['test-auth-valid', hashKey(raw1)]
  );

  const raw2 = 'disc_' + crypto.randomBytes(16).toString('hex');
  revokedKey = raw2;
  const { rows } = await pool.query<{ id: string }>(
    'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2) RETURNING id',
    ['test-auth-revoked', hashKey(raw2)]
  );
  await pool.query('UPDATE api_keys SET revoked_at = NOW() WHERE id = $1', [rows[0].id]);
});

afterAll(async () => {
  await pool.query("DELETE FROM api_keys WHERE label IN ('test-auth-valid', 'test-auth-revoked')");
});

describe('auth middleware', () => {
  it('allows a write request with a valid key', async () => {
    const res = await request(app)
      .post('/api/v1/artists')
      .set('Authorization', `Bearer ${validKey}`)
      .send({ name: 'Auth Test Artist' });
    expect(res.status).toBe(201);
    if (res.body.id) await pool.query('DELETE FROM artists WHERE id = $1', [res.body.id]);
  });

  it('rejects a request with no auth header', async () => {
    const res = await request(app).post('/api/v1/artists').send({ name: 'X' });
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('INVALID_API_KEY');
  });

  it('rejects a request with an unknown key', async () => {
    const res = await request(app)
      .post('/api/v1/artists')
      .set('Authorization', 'Bearer disc_notarealkey000000000000000000000')
      .send({ name: 'X' });
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('INVALID_API_KEY');
  });

  it('rejects a request with a revoked key', async () => {
    const res = await request(app)
      .post('/api/v1/artists')
      .set('Authorization', `Bearer ${revokedKey}`)
      .send({ name: 'X' });
    expect(res.status).toBe(401);
    expect(res.body.code).toBe('INVALID_API_KEY');
  });

  it('allows GET requests without auth', async () => {
    const res = await request(app).get('/api/v1/artists');
    expect(res.status).toBe(200);
  });
});
