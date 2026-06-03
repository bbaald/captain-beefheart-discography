/**
 * scripts/apply-album-artwork.ts
 *
 * Reads data/album-artwork.json and updates cover_art_url in the DB.
 * By default applies exact + fuzzy matches. Pass --exact-only to restrict.
 *
 * Usage:
 *   npm run apply:album-artwork              # exact + fuzzy
 *   npm run apply:album-artwork -- --exact-only
 */

import 'dotenv/config';
import { readFileSync } from 'fs';
import { pool } from '../src/db/client';

interface ArtworkResult {
  album_id:    string;
  title:       string;
  artwork_url: string | null;
  confidence:  'exact' | 'fuzzy' | 'none';
}

async function main() {
  const exactOnly = process.argv.includes('--exact-only');
  const results: ArtworkResult[] = JSON.parse(
    readFileSync('data/album-artwork.json', 'utf8'),
  );

  const candidates = results.filter(
    r => r.artwork_url &&
         (exactOnly ? r.confidence === 'exact' : r.confidence !== 'none'),
  );

  console.log(`Applying ${candidates.length} artwork URLs (${exactOnly ? 'exact only' : 'exact + fuzzy'})…`);

  let applied = 0;
  let skipped  = 0;

  for (const r of candidates) {
    const { rowCount } = await pool.query(
      `UPDATE albums SET cover_art_url = $1 WHERE id = $2`,
      [r.artwork_url, r.album_id],
    );
    if (rowCount && rowCount > 0) {
      console.log(`  ✓ ${r.title}`);
      applied++;
    } else {
      skipped++;
    }
  }

  console.log(`\nDone. Applied: ${applied}  Skipped: ${skipped}`);
  await pool.end();
}

main().catch(e => { console.error(e); process.exit(1); });
