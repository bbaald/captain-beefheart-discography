import 'dotenv/config';
import { Pool } from 'pg';
import { readdir, readFile } from 'fs/promises';
import path from 'path';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function migrate() {
  await pool.query(`
    CREATE TABLE IF NOT EXISTS _migrations (
      name   TEXT        PRIMARY KEY,
      run_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
    )
  `);

  const { rows } = await pool.query<{ name: string }>('SELECT name FROM _migrations ORDER BY name');
  const ran = new Set(rows.map(r => r.name));

  const dir = path.join(__dirname, '../src/db/migrations');
  const files = (await readdir(dir)).filter(f => f.endsWith('.sql')).sort();

  let count = 0;
  for (const file of files) {
    if (ran.has(file)) continue;
    console.log(`Running: ${file}`);
    const sql = await readFile(path.join(dir, file), 'utf8');
    await pool.query(sql);
    await pool.query('INSERT INTO _migrations (name) VALUES ($1)', [file]);
    count++;
  }

  console.log(count === 0 ? 'Already up to date.' : `${count} migration(s) applied.`);
  await pool.end();
}

migrate().catch(err => { console.error(err); process.exit(1); });
