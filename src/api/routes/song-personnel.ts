import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth } from '../middleware/auth';

const router = Router({ mergeParams: true });

const VALID_ROLES = ['musician', 'songwriter', 'producer', 'engineer'] as const;

const addSchema = z.object({
  personnel_id: z.string().uuid(),
  role:         z.enum(VALID_ROLES),
  instrument:   z.string().optional(),
});

// POST /api/v1/songs/:id/personnel
router.post('/:id/personnel', requireAuth, async (req, res, next) => {
  try {
    const parsed = addSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }
    const { personnel_id, role, instrument = null } = parsed.data;
    const song_id = req.params.id;

    const { rows } = await pool.query(
      `INSERT INTO song_personnel (song_id, personnel_id, role, instrument)
       VALUES ($1, $2, $3, $4)
       RETURNING *`,
      [song_id, personnel_id, role, instrument]
    );
    res.status(201).json(rows[0]);
  } catch (err: unknown) {
    const pg = err as { code?: string };
    if (pg.code === '23503') {
      res.status(404).json({ error: 'Song or person not found', code: 'NOT_FOUND' });
      return;
    }
    if (pg.code === '23505') {
      res.status(409).json({
        error: 'This person already holds that role on this song',
        code: 'CONFLICT',
      });
      return;
    }
    next(err);
  }
});

// DELETE /api/v1/songs/:id/personnel/:personnelId/roles/:role
router.delete('/:id/personnel/:personnelId/roles/:role', requireAuth, async (req, res, next) => {
  try {
    const { role } = req.params;
    if (!(VALID_ROLES as readonly string[]).includes(role)) {
      res.status(422).json({ error: `role must be one of: ${VALID_ROLES.join(', ')}`, code: 'INVALID_ROLE' });
      return;
    }
    const { rows } = await pool.query(
      `DELETE FROM song_personnel
       WHERE song_id = $1 AND personnel_id = $2 AND role = $3
       RETURNING song_id`,
      [req.params.id, req.params.personnelId, role]
    );
    if (rows.length === 0) {
      res.status(404).json({ error: 'Credit not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err) { next(err); }
});

export default router;
