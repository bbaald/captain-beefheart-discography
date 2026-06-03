import 'dotenv/config';
import crypto from 'crypto';
import { Pool } from 'pg';
import { hashKey } from '../src/api/middleware/auth';

const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function seedKey() {
  const label = process.argv[2] ?? 'bootstrap';
  const raw = 'disc_' + crypto.randomBytes(32).toString('hex');
  const hash = hashKey(raw);

  const { rows } = await pool.query<{ id: string; label: string; created_at: Date }>(
    'INSERT INTO api_keys (label, key_hash) VALUES ($1, $2) RETURNING id, label, created_at',
    [label, hash]
  );

  console.log('\nAPI key created:');
  console.log(`  Label:      ${rows[0].label}`);
  console.log(`  Key:        ${raw}`);
  console.log(`  ID:         ${rows[0].id}`);
  console.log(`  Created at: ${rows[0].created_at.toISOString()}`);
  console.log('\nStore this key securely — it will not be shown again.\n');

  await pool.end();
}

seedKey().catch(err => { console.error(err); process.exit(1); });
