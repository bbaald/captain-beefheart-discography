import { Router } from 'express';
import { pool } from '../../db/client';

const router = Router();

const VALID_TYPES = new Set(['song', 'album']);

router.get('/', async (req, res, next) => {
  try {
    const q = (req.query.q as string | undefined)?.trim();
    if (!q) {
      res.status(400).json({ error: 'q parameter is required', code: 'MISSING_QUERY' });
      return;
    }

    const type = req.query.type as string | undefined;
    if (type && !VALID_TYPES.has(type)) {
      res.status(400).json({ error: 'type must be "song" or "album"', code: 'INVALID_TYPE' });
      return;
    }

    const pattern = `%${q}%`;

    const [songResult, albumResult] = await Promise.all([
      type === 'album'
        ? Promise.resolve({ rows: [] as { id: string; name: string; release_year: number | null }[] })
        : pool.query<{ id: string; name: string; release_year: number | null }>(
            `SELECT id, title AS name, release_year
             FROM songs
             WHERE title ILIKE $1
             ORDER BY name`,
            [pattern]
          ),
      type === 'song'
        ? Promise.resolve({ rows: [] as { id: string; name: string; release_year: number | null }[] })
        : pool.query<{ id: string; name: string; release_year: number | null }>(
            `SELECT id, title AS name, release_year
             FROM albums
             WHERE title ILIKE $1
             ORDER BY name`,
            [pattern]
          ),
    ]);

    res.json({
      query: q,
      results: {
        songs:  songResult.rows,
        albums: albumResult.rows,
      },
    });
  } catch (err) { next(err); }
});

export default router;
