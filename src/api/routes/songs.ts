import { Router } from 'express';
import { z } from 'zod';
import { pool } from '../../db/client';
import { requireAuth } from '../middleware/auth';

const router = Router();

const songCreateSchema = z.object({
  title:                z.string().min(1),
  artist_id:            z.string().uuid(),
  media_type:           z.enum(['audio', 'video']),
  running_time_seconds: z.number().int().positive(),
  release_year:         z.number().int().min(1900).max(2100),
  source_list:          z.array(z.string().min(1)).min(1),
  credited_as:          z.string().optional(),
  recording_type:       z.enum(['studio', 'live']).optional(),
  release_date:         z.string().date().optional(),
  recording_date:       z.string().date().optional(),
  recording_year:       z.number().int().min(1900).max(2100).optional(),
  lyrics:               z.string().optional(),
  cover_art_url:        z.string().url().optional(),
  recording_url:        z.string().url().optional(),
  record_label:         z.string().optional(),
  catalog_number:       z.string().optional(),
  liner_notes:          z.string().optional(),
});

const songPatchSchema = songCreateSchema.partial();

const SORT_MAP: Record<string, string> = {
  title:        'title',
  release_year: 'release_year DESC NULLS LAST, title',
};

router.get('/', async (req, res, next) => {
  try {
    const { q, media_type, recording_type, year, album_id, sort, limit, offset } = req.query as Record<string, string | undefined>;

    const conditions: string[] = [];
    const values: unknown[] = [];
    let i = 1;

    if (q)              { conditions.push(`title ILIKE $${i++}`);       values.push(`%${q}%`); }
    if (media_type)     { conditions.push(`media_type = $${i++}`);      values.push(media_type); }
    if (recording_type) { conditions.push(`recording_type = $${i++}`);  values.push(recording_type); }
    if (year)           { conditions.push(`release_year = $${i++}`);    values.push(Number(year)); }
    if (album_id)       { conditions.push(`id IN (SELECT song_id FROM song_albums WHERE album_id = $${i++})`); values.push(album_id); }

    const where   = conditions.length ? `WHERE ${conditions.join(' AND ')}` : '';
    const orderBy = SORT_MAP[sort ?? ''] ?? 'release_year DESC NULLS LAST, title';
    const lim     = Math.min(Math.max(1, Number(limit)  || 50),  200);
    const off     = Math.max(0,             Number(offset) || 0);

    values.push(lim, off);
    const { rows } = await pool.query(
      `SELECT * FROM songs ${where} ORDER BY ${orderBy} LIMIT $${i++} OFFSET $${i}`,
      values
    );
    res.json(rows);
  } catch (err) { next(err); }
});

router.get('/:id', async (req, res, next) => {
  try {
    const [songResult, albumsResult, personnelResult] = await Promise.all([
      pool.query('SELECT * FROM songs WHERE id = $1', [req.params.id]),
      pool.query(
        `SELECT a.*, sa.sequence_number
         FROM song_albums sa
         JOIN albums a ON a.id = sa.album_id
         WHERE sa.song_id = $1
         ORDER BY a.release_year NULLS LAST, a.title`,
        [req.params.id]
      ),
      pool.query(
        `SELECT p.*, sp.role, sp.instrument
         FROM song_personnel sp
         JOIN personnel p ON p.id = sp.personnel_id
         WHERE sp.song_id = $1
         ORDER BY sp.role, p.name`,
        [req.params.id]
      ),
    ]);

    if (songResult.rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.json({
      ...songResult.rows[0],
      albums:    albumsResult.rows,
      personnel: personnelResult.rows,
    });
  } catch (err) { next(err); }
});

router.post('/', requireAuth, async (req, res, next) => {
  try {
    const parsed = songCreateSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }
    const d = parsed.data;
    const { rows } = await pool.query(
      `INSERT INTO songs
        (title, artist_id, credited_as, media_type, recording_type,
         running_time_seconds, release_date, release_year, recording_date,
         recording_year, lyrics, cover_art_url, recording_url, record_label,
         catalog_number, liner_notes, source_list)
       VALUES ($1,$2,$3,$4,$5,$6,$7,$8,$9,$10,$11,$12,$13,$14,$15,$16,$17)
       RETURNING *`,
      [
        d.title, d.artist_id, d.credited_as ?? null, d.media_type, d.recording_type ?? null,
        d.running_time_seconds, d.release_date ?? null, d.release_year, d.recording_date ?? null,
        d.recording_year ?? null, d.lyrics ?? null, d.cover_art_url ?? null,
        d.recording_url ?? null, d.record_label ?? null, d.catalog_number ?? null,
        d.liner_notes ?? null, d.source_list,
      ]
    );
    res.status(201).json(rows[0]);
  } catch (err) { next(err); }
});

router.patch('/:id', requireAuth, async (req, res, next) => {
  try {
    const parsed = songPatchSchema.safeParse(req.body);
    if (!parsed.success) {
      res.status(422).json({ error: 'Validation failed', issues: parsed.error.issues });
      return;
    }

    const fields = parsed.data;
    const updates: string[] = [];
    const values: unknown[] = [];
    let i = 1;

    const cols = [
      'title', 'artist_id', 'credited_as', 'media_type', 'recording_type',
      'running_time_seconds', 'release_date', 'release_year', 'recording_date',
      'recording_year', 'lyrics', 'cover_art_url', 'recording_url', 'record_label',
      'catalog_number', 'liner_notes', 'source_list',
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
      `UPDATE songs SET ${updates.join(', ')} WHERE id = $${i} RETURNING *`,
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
    const { rows } = await pool.query('DELETE FROM songs WHERE id = $1 RETURNING id', [req.params.id]);
    if (rows.length === 0) {
      res.status(404).json({ error: 'Not found', code: 'NOT_FOUND' });
      return;
    }
    res.status(204).send();
  } catch (err) { next(err); }
});

export default router;
