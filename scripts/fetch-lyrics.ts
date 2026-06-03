/**
 * scripts/fetch-lyrics.ts
 *
 * Fetches lyrics for every song via lyrics.ovh (no auth required).
 * Writes results to data/lyrics.json for review before applying.
 *
 * Usage: npm run fetch:lyrics
 */

import 'dotenv/config';
import { writeFileSync, mkdirSync } from 'fs';
import { pool } from '../src/db/client';

const DELAY_MS       = 500;
const RETRY_DELAY_MS = 5000;
const ARTIST         = 'Captain Beefheart';

interface LyricsResult {
  song_id:    string;
  title:      string;
  lyrics:     string | null;
  status:     'found' | 'not_found' | 'error';
}

function sleep(ms: number) {
  return new Promise(r => setTimeout(r, ms));
}

async function fetchLyrics(title: string, retried = false): Promise<string | null> {
  const url = `https://api.lyrics.ovh/v1/${encodeURIComponent(ARTIST)}/${encodeURIComponent(title)}`;
  const res = await fetch(url);

  if (res.status === 429 && !retried) {
    await sleep(RETRY_DELAY_MS);
    return fetchLyrics(title, true);
  }
  if (!res.ok) return null;

  const data = await res.json() as { lyrics?: string; error?: string };
  if (data.error || !data.lyrics) return null;

  return data.lyrics.trim();
}

async function main() {
  const { rows } = await pool.query<{ id: string; title: string }>(
    `SELECT id, title FROM songs ORDER BY title`,
  );

  console.log(`Fetching lyrics for ${rows.length} songs…\n`);

  const results: LyricsResult[] = [];
  let found = 0, notFound = 0;

  for (const song of rows) {
    process.stdout.write(`  ${song.title} … `);
    try {
      const lyrics = await fetchLyrics(song.title);
      await sleep(DELAY_MS);

      if (lyrics) {
        process.stdout.write(`found (${lyrics.split('\n').length} lines)\n`);
        results.push({ song_id: song.id, title: song.title, lyrics, status: 'found' });
        found++;
      } else {
        process.stdout.write(`not found\n`);
        results.push({ song_id: song.id, title: song.title, lyrics: null, status: 'not_found' });
        notFound++;
      }
    } catch (e) {
      process.stdout.write(`error: ${e}\n`);
      results.push({ song_id: song.id, title: song.title, lyrics: null, status: 'error' });
      notFound++;
    }
  }

  mkdirSync('data', { recursive: true });
  writeFileSync('data/lyrics.json', JSON.stringify(results, null, 2));

  console.log(`\nDone. found: ${found}  not found: ${notFound}`);
  console.log('Run: npm run apply:lyrics');

  await pool.end();
}

main().catch(e => { console.error(e); process.exit(1); });
