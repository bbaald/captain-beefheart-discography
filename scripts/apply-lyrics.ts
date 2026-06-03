/**
 * scripts/apply-lyrics.ts
 *
 * Reads data/lyrics.json and writes lyrics to the songs table.
 *
 * Usage: npm run apply:lyrics
 */

import 'dotenv/config';
import { readFileSync } from 'fs';
import { pool } from '../src/db/client';

interface LyricsResult {
  song_id: string;
  title:   string;
  lyrics:  string | null;
  status:  string;
}

async function main() {
  const results: LyricsResult[] = JSON.parse(readFileSync('data/lyrics.json', 'utf8'));
  const candidates = results.filter(r => r.lyrics);

  console.log(`Applying lyrics to ${candidates.length} songs…`);

  let applied = 0;
  for (const r of candidates) {
    await pool.query(`UPDATE songs SET lyrics = $1 WHERE id = $2`, [r.lyrics, r.song_id]);
    console.log(`  ✓ ${r.title}`);
    applied++;
  }

  console.log(`\nDone. Applied: ${applied}`);
  await pool.end();
}

main().catch(e => { console.error(e); process.exit(1); });
