import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth } from '../middleware/auth';

const router = Router({ mergeParams: true });

const addSchema = z.object({
  album_id:        z.string().uuid(),
  sequence_number: z.number().int().min(1).max(999),
});

// POST /api/v1/songs/:id/albums
router.post('/:id/albums', requireAuth, async (req, res, next) => {
  try {
    const parsed = addSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }
    const { album_id, sequence_number } = parsed.data;
    const song_id = req.params.id;

    const { rows } = await pool.query(
      `INSERT INTO song_albums (song_id, album_id, sequence_number)
       VALUES ($1, $2, $3)
       RETURNING *`,
      [song_id, album_id, sequence_number]
    );
    res.status(201).json(rows[0]);
  } catch (err: unknown) {
    const pg = err as { code?: string; constraint?: string };
    if (pg.code === '23503') {
      res.status(404).json({ error: 'Song or album not found', code: 'NOT_FOUND' });
      return;
    }
    if (pg.code === '23505') {
      const msg = pg.constraint?.includes('sequence')
        ? 'That track number is already taken on this album'
        : 'Song is already on this album';
      res.status(409).json({ error: msg, code: 'CONFLICT' });
      return;
    }
    next(err);
  }
});

// DELETE /api/v1/songs/:id/albums/:albumId
router.delete('/:id/albums/:albumId', requireAuth, async (req, res, next) => {
  try {
    const { rows } = await pool.query(
      'DELETE FROM song_albums WHERE song_id = $1 AND album_id = $2 RETURNING song_id',
      [req.params.id, req.params.albumId]
    );
    if (rows.length === 0) {
      res.status(404).json({ error: 'Relationship not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err) { next(err); }
});

export default router;
