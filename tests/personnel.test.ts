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
    ['test-personnel', hashKey(raw)]
  );
});

afterAll(async () => {
  await pool.query("DELETE FROM api_keys WHERE label = 'test-personnel'");
});

describe('Personnel CRUD', () => {
  it('creates a person', async () => {
    const res = await request(app)
      .post('/api/v1/personnel')
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ name: 'Jane Smith', sort_name: 'Smith, Jane' });
    expect(res.status).toBe(201);
    expect(res.body.name).toBe('Jane Smith');
    createdId = res.body.id;
  });

  it('reads the person', async () => {
    const res = await request(app).get(`/api/v1/personnel/${createdId}`);
    expect(res.status).toBe(200);
    expect(res.body.sort_name).toBe('Smith, Jane');
  });

  it('lists personnel', async () => {
    const res = await request(app).get('/api/v1/personnel');
    expect(res.status).toBe(200);
    expect(Array.isArray(res.body)).toBe(true);
    expect(res.body.some((p: { id: string }) => p.id === createdId)).toBe(true);
  });

  it('updates the person', async () => {
    const res = await request(app)
      .patch(`/api/v1/personnel/${createdId}`)
      .set('Authorization', `Bearer ${apiKey}`)
      .send({ sort_name: 'Smith, J.' });
    expect(res.status).toBe(200);
    expect(res.body.sort_name).toBe('Smith, J.');
  });

  it('returns 404 for unknown person', async () => {
    const res = await request(app).get('/api/v1/personnel/00000000-0000-0000-0000-000000000000');
    expect(res.status).toBe(404);
  });

  it('deletes the person', async () => {
    const res = await request(app)
      .delete(`/api/v1/personnel/${createdId}`)
      .set('Authorization', `Bearer ${apiKey}`);
    expect(res.status).toBe(204);
  });
});
