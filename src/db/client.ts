import 'dotenv/config';
import { Pool } from 'pg';
import dns from 'dns/promises';

let _pool: Pool | null = null;

export async function initPool(): Promise<void> {
  const rawUrl = process.env.DATABASE_URL;
  if (!rawUrl) throw new Error('DATABASE_URL is not set');

  const url = new URL(rawUrl);
  const { address: ipv4 } = await dns.lookup(url.hostname, { family: 4 });
  url.hostname = ipv4;

  _pool = new Pool({ connectionString: url.toString() });
}

// Proxy so existing `pool.query(...)` calls in routes work without changes.
// The real pool is guaranteed to exist by the time any request is handled,
// since server.ts calls initPool() before app.listen().
export const pool = new Proxy({} as Pool, {
  get(_target, prop) {
    if (!_pool) throw new Error('Pool not initialized — call initPool() before handling requests.');
    const value = (_pool as any)[prop];
    return typeof value === 'function' ? value.bind(_pool) : value;
  },
});
