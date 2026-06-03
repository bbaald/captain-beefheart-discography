import crypto from 'crypto';
import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth, hashKey } from '../middleware/auth';

const router = Router();

router.get('/', requireAuth, async (_req, res, next) => {
  try {
    const { rows } = await pool.query(
      'SELECT id, label, created_at, last_used_at, revoked_at FROM api_keys ORDER BY created_at DESC'
    );
    res.json(rows);
  } catch (err) { next(err); }
});

const createSchema = z.object({ label: z.string().min(1) });

router.post('/', requireAuth, async (req, res, next) => {
  try {
    const parsed = createSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }

    const raw = 'disc_' + crypto.randomBytes(32).toString('hex');
    const hash = hashKey(raw);

    const { rows } = await pool.query(
      'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2) RETURNING id, label, created_at',
      [parsed.data.label, hash]
    );

    res.status(201).json({ ...rows[0], key: raw });
  } catch (err) { next(err); }
});

router.delete('/:id', requireAuth, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      'UPDATE api_keys SET revoked_at = NOW() WHERE id = $1 AND revoked_at IS NULL RETURNING id',
      [req.params.id]
    );
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err) { next(err); }
});

export default router;
