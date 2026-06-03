/**
 * scripts/apply-apple-music-urls.ts
 *
 * Reads data/apple-music-urls.json (produced by fetch-apple-music-urls.ts)
 * and sets songs.recording_url for every 'exact' confidence match.
 *
 * Idempotent: songs that already have a recording_url are skipped.
 * Fuzzy and none-confidence results are never written automatically.
 *
 * Usage:  npm run apply:apple-music-urls
 */

import 'dotenv/config';
import { readFileSync } from 'fs';
import { pool } from '../src/db/client';
import type { UrlData } from './fetch-apple-music-urls';

async function main() {
  const raw = readFileSync('data/apple-music-urls.json', 'utf-8');
  const data = JSON.parse(raw) as UrlData;

  console.log(`Loaded ${data.total} results from data/apple-music-urls.json`);
  console.log(`Fetched: ${data.fetched_at}`);
  console.log(`Summary: ${data.exact} exact / ${data.fuzzy} fuzzy / ${data.none} none\n`);

  let applied = 0;
  let skippedFuzzy = 0;
  let skippedNone = 0;
  let skippedAlreadySet = 0;

  for (const result of data.results) {
    if (result.confidence !== 'exact' || !result.apple_music_url) {
      if (result.confidence === 'fuzzy') skippedFuzzy++;
      else skippedNone++;
      continue;
    }

    const { rowCount } = await pool.query(
      `UPDATE songs
       SET recording_url = $1, updated_at = NOW()
       WHERE id = $2
         AND recording_url IS NULL`,
      [result.apple_music_url, result.song_id],
    );

    if (rowCount && rowCount > 0) {
      applied++;
    } else {
      skippedAlreadySet++;
    }
  }

  console.log('─────────────────────────────────────────');
  console.log(`Applied:           ${applied}`);
  console.log(`Skipped (fuzzy):   ${skippedFuzzy}`);
  console.log(`Skipped (none):    ${skippedNone}`);
  console.log(`Skipped (has URL): ${skippedAlreadySet}`);
  console.log('─────────────────────────────────────────');

  if (skippedFuzzy > 0) {
    console.log(`\n${skippedFuzzy} fuzzy matches were not applied automatically.`);
    console.log('Review data/apple-music-urls.json and manually update if correct:');
    console.log('  UPDATE songs SET recording_url = \'<url>\' WHERE id = \'<song_id>\';');
  }

  await pool.end();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
