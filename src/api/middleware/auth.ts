import crypto from 'crypto';
import { Request, Response, NextFunction } from 'express';
import { pool } from '../../db/client';

export function hashKey(raw: string): string {
  return crypto.createHash('sha256').update(raw).digest('hex');
}

export async function requireAuth(req: Request, res: Response, next: NextFunction): Promise<void> {
  const header = req.headers.authorization;
  if (!header?.startsWith('Bearer ')) {
    res.status(401).json({ error: 'Unauthorized', code: 'INVALID_API_KEY' });
    return;
  }

  const raw = header.slice(7);
  const hash = hashKey(raw);

  const { rows } = await pool.query<{ id: string }>(
    'SELECT id FROM api_keys WHERE key_hash = $1 AND revoked_at IS NULL',
    [hash]
  );

  if (rows.length === 0) {
    res.status(401).json({ error: 'Unauthorized', code: 'INVALID_API_KEY' });
    return;
  }

  pool.query('UPDATE api_keys SET last_used_at = NOW() WHERE id = $1', [rows[0].id]).catch(() => {});

  next();
}
