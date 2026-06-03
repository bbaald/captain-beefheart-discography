import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth } from '../middleware/auth';

const router = Router();

const artistSchema = z.object({
  name: z.string().min(1),
  sort_name: z.string().optional(),
  aliases: z.array(z.string()).optional(),
});

router.get('/', async (_req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM artists ORDER BY sort_name NULLS LAST, name');
    res.json(rows);
  } catch (err) { next(err); }
});

router.get('/:id', async (req, res, next) => {
  try {
    const { rows } = await pool.query('SELECT * FROM artists WHERE id = $1', [req.params.id]);
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.json(rows[0]);
  } catch (err) { next(err); }
});

router.post('/', requireAuth, async (req, res, next) => {
  try {
    const parsed = artistSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }
    const { name, sort_name = null, aliases = [] } = parsed.data;
    const { rows } = await pool.query(
      'INSERT INTO artists (name, sort_name, aliases) VALUES ($1, $2, $3) RETURNING *',
      [name, sort_name, aliases]
    );
    res.status(201).json(rows[0]);
  } catch (err) { next(err); }
});

router.patch('/:id', requireAuth, async (req, res, next) => {
  try {
    const parsed = artistSchema.partial().safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }

    const fields = parsed.data;
    const updates: string[] = [];
    const values: unknown[] = [];
    let i = 1;

    if (fields.name !== undefined)      { updates.push(`name = $${i++}`);      values.push(fields.name); }
    if (fields.sort_name !== undefined) { updates.push(`sort_name = $${i++}`); values.push(fields.sort_name); }
    if (fields.aliases !== undefined)   { updates.push(`aliases = $${i++}`);   values.push(fields.aliases); }

    if (updates.length === 0) {
      res.status(422).json({ error: 'No updatable fields provided', code: 'NO_FIELDS' });
      return;
    }

    updates.push(`updated_at = NOW()`);
    values.push(req.params.id);

    const { rows } = await pool.query(
      `UPDATE artists SET ${updates.join(', ')} WHERE id = $${i} RETURNING *`,
      values
    );
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.json(rows[0]);
  } catch (err) { next(err); }
});

router.delete('/:id', requireAuth, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      'DELETE FROM artists WHERE id = $1 RETURNING id',
      [req.params.id]
    );
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err: unknown) {
    const pg = err as { code?: string };
    if (pg.code === '23503') {
      res.status(409).json({ error: 'Artist has associated records', code: 'CONFLICT' });
      return;
    }
    next(err);
  }
});

export default router;
