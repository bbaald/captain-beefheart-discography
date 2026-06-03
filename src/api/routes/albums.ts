import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth } from '../middleware/auth';

const router = Router();

const albumSchema = z.object({
  artist_id:      z.string().uuid(),
  title:          z.string().min(1),
  credited_as:    z.string().optional(),
  album_type:     z.enum(['LP', 'EP', 'Single', 'Compilation', 'Live']).optional(),
  release_date:   z.string().date().optional(),
  release_year:   z.number().int().min(1900).max(2100).optional(),
  record_label:   z.string().optional(),
  catalog_number: z.string().optional(),
  cover_art_url:  z.string().url().optional(),
  liner_notes:    z.string().optional(),
  source_list:    z.array(z.string().min(1)).optional(),
});

const SORT_MAP: Record<string, string> = {
  title:        'title',
  release_year: 'release_year DESC NULLS LAST, title',
};

router.get('/', async (req, res, next) => {
  try {
    const { album_type, year, sort, limit, offset } = req.query as Record<string, string | undefined>;

    const conditions: string[] = [];
    const values: unknown[] = [];
    let i = 1;

    if (album_type) { conditions.push(`album_type = $${i++}`);   values.push(album_type); }
    if (year)       { conditions.push(`release_year = $${i++}`); values.push(Number(year)); }

    const where   = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
    const orderBy = SORT_MAP[sort ?? ''] ?? 'release_year DESC NULLS LAST, title';
    const lim     = Math.min(Math.max(1, Number(limit)  || 50),  200);
    const off     = Math.max(0,             Number(offset) || 0);

    values.push(lim, off);
    const { rows } = await pool.query(
      `SELECT * FROM albums ${where} ORDER BY ${orderBy} LIMIT $${i++} OFFSET $${i}`,
      values
    );
    res.json(rows);
  } catch (err) { next(err); }
});

router.get('/:id', async (req, res, next) => {
  try {
    const [albumResult, songsResult] = await Promise.all([
      pool.query('SELECT * FROM albums WHERE id = $1', [req.params.id]),
      pool.query(
        `SELECT s.*, sa.sequence_number
         FROM song_albums sa
         JOIN songs s ON s.id = sa.song_id
         WHERE sa.album_id = $1
         ORDER BY sa.sequence_number`,
        [req.params.id]
      ),
    ]);

    if (albumResult.rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.json({
      ...albumResult.rows[0],
      songs: songsResult.rows,
    });
  } catch (err) { next(err); }
});

router.post('/', requireAuth, async (req, res, next) => {
  try {
    const parsed = albumSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }
    const d = parsed.data;
    const { rows } = await pool.query(
      `INSERT INTO albums
        (artist_id, title, credited_as, album_type, release_date, release_year,
         record_label, catalog_number, cover_art_url, liner_notes, source_list)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11)
       RETURNING *`,
      [
        d.artist_id, d.title, d.credited_as ?? null, d.album_type ?? null,
        d.release_date ?? null, d.release_year ?? null, d.record_label ?? null,
        d.catalog_number ?? null, d.cover_art_url ?? null, d.liner_notes ?? null,
        d.source_list ?? [],
      ]
    );
    res.status(201).json(rows[0]);
  } catch (err) { next(err); }
});

router.patch('/:id', requireAuth, async (req, res, next) => {
  try {
    const parsed = albumSchema.partial().safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }

    const fields = parsed.data;
    const updates: string[] = [];
    const values: unknown[] = [];
    let i = 1;

    const cols = [
      'artist_id', 'title', 'credited_as', 'album_type', 'release_date',
      'release_year', 'record_label', 'catalog_number', 'cover_art_url',
      'liner_notes', 'source_list',
    ] as const;

    for (const col of cols) {
      if (fields[col] !== undefined) {
        updates.push(`${col} = $${i++}`);
        values.push(fields[col]);
      }
    }

    if (updates.length === 0) {
      res.status(422).json({ error: 'No updatable fields provided', code: 'NO_FIELDS' });
      return;
    }

    updates.push(`updated_at = NOW()`);
    values.push(req.params.id);

    const { rows } = await pool.query(
      `UPDATE albums SET ${updates.join(', ')} WHERE id = $${i} RETURNING *`,
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
    const { rows } = await pool.query('DELETE FROM albums WHERE id = $1 RETURNING id', [req.params.id]);
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err: unknown) {
    const pg = err as { code?: string };
    if (pg.code === '23503') {
      res.status(409).json({ error: 'Album has associated records', code: 'CONFLICT' });
      return;
    }
    next(err);
  }
});

export default router;
