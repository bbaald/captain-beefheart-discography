/**
 * scripts/fetch-apple-music-urls.ts
 *
 * Searches the iTunes Search API for every song in the database and writes
 * structured match results to data/apple-music-urls.json for review before
 * applying URLs to the DB.
 *
 * Usage:  npm run search:apple-music
 * Output: data/apple-music-urls.json
 */

import 'dotenv/config';
import { writeFileSync, mkdirSync } from 'fs';
import { pool } from '../src/db/client';

const ITUNES_SEARCH = 'https://itunes.apple.com/search';
const DELAY_MS = 600;        // base delay between requests
const RETRY_DELAY_MS = 8000; // wait after 429/403 before retrying

// ─── Types ────────────────────────────────────────────────────────────────────

export type Confidence = 'exact' | 'fuzzy' | 'none';

export interface UrlResult {
  song_id: string;
  title: string;
  search_term: string;          // what was actually sent to iTunes
  apple_music_title: string | null;
  apple_music_url: string | null;
  confidence: Confidence;
}

export interface UrlData {
  fetched_at: string;
  total: number;
  exact: number;
  fuzzy: number;
  none: number;
  results: UrlResult[];
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

function sleep(ms: number) {
  return new Promise<void>(resolve => setTimeout(resolve, ms));
}

/** Lowercase, strip punctuation, collapse whitespace. */
function normalise(s: string): string {
  return s
    .toLowerCase()
    .replace(/[^a-z0-9\s]/g, '')
    .replace(/\s+/g, ' ')
    .trim();
}

/**
 * Strip trailing duration suffixes like " 3:56", " 4:18", " (3.27)" that
 * live-album scraped titles sometimes include.
 */
function stripDuration(title: string): string {
  return title
    .replace(/\s+\d+:\d+$/, '')          // "Title 3:56"
    .replace(/\s+\d+\.\d+$/, '')          // "Title 3.56"
    .replace(/\s*\(\d+[.:]\d+\)\s*$/, '') // "Title (3.56)"
    .trim();
}

/** Levenshtein distance (capped at maxDist+1 for speed). */
function levenshtein(a: string, b: string, maxDist = 3): number {
  if (Math.abs(a.length - b.length) > maxDist) return maxDist + 1;
  const dp: number[] = Array.from({ length: b.length + 1 }, (_, i) => i);
  for (let i = 1; i <= a.length; i++) {
    let prev = i;
    for (let j = 1; j <= b.length; j++) {
      const curr = a[i - 1] === b[j - 1]
        ? dp[j - 1]
        : 1 + Math.min(dp[j - 1], dp[j], prev);
      dp[j - 1] = prev;
      prev = curr;
    }
    dp[b.length] = prev;
  }
  return dp[b.length];
}

function score(dbTitle: string, itunesTitle: string): Confidence {
  const a = normalise(dbTitle);
  const b = normalise(itunesTitle);
  if (a === b) return 'exact';
  if (a.includes(b) || b.includes(a)) return 'fuzzy';
  if (levenshtein(a, b, 2) <= 2) return 'fuzzy';
  return 'none';
}

// ─── iTunes search ─────────────────────────────────────────────────────────────

interface ItunesTrack {
  trackName: string;
  artistName: string;
  trackViewUrl?: string;
}

/** Fetch from iTunes with one retry on 429/403. */
async function searchItunes(title: string): Promise<ItunesTrack[]> {
  const term = encodeURIComponent(`${title} captain beefheart`);
  const url = `${ITUNES_SEARCH}?term=${term}&media=music&entity=song&limit=5`;

  for (let attempt = 0; attempt < 2; attempt++) {
    const res = await fetch(url, { headers: { Accept: 'application/json' } });

    if (res.ok) {
      const json = await res.json() as { results?: ItunesTrack[] };
      return json.results ?? [];
    }

    if ((res.status === 429 || res.status === 403) && attempt === 0) {
      // Back off and retry once
      process.stdout.write(` [${res.status}→wait] `);
      await sleep(RETRY_DELAY_MS);
      continue;
    }

    throw new Error(`iTunes API ${res.status}`);
  }

  return [];
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  const { rows: songs } = await pool.query<{ id: string; title: string }>(
    `SELECT id, title FROM songs ORDER BY title`,
  );

  console.log(`Searching iTunes for ${songs.length} songs…\n`);

  const results: UrlResult[] = [];
  let exact = 0, fuzzy = 0, none = 0;

  for (const song of songs) {
    await sleep(DELAY_MS);

    // Strip duration suffix from live-album titles before searching
    const searchTitle = stripDuration(song.title);

    let result: UrlResult = {
      song_id: song.id,
      title: song.title,
      search_term: searchTitle,
      apple_music_title: null,
      apple_music_url: null,
      confidence: 'none',
    };

    try {
      const tracks = await searchItunes(searchTitle);

      if (tracks.length > 0) {
        let best: { track: ItunesTrack; confidence: Confidence } | null = null;

        for (const track of tracks) {
          const c = score(searchTitle, track.trackName);
          if (c === 'exact') {
            best = { track, confidence: 'exact' };
            break;
          }
          if (c === 'fuzzy' && (!best || best.confidence === 'none')) {
            best = { track, confidence: 'fuzzy' };
          }
        }

        if (best) {
          result = {
            song_id: song.id,
            title: song.title,
            search_term: searchTitle,
            apple_music_title: best.track.trackName,
            apple_music_url: best.track.trackViewUrl ?? null,
            confidence: best.confidence,
          };
        }
      }
    } catch (err) {
      console.error(`\n  ERROR "${song.title}": ${err}`);
    }

    results.push(result);

    if (result.confidence === 'exact') { exact++; process.stdout.write('✓'); }
    else if (result.confidence === 'fuzzy') { fuzzy++; process.stdout.write('~'); }
    else { none++; process.stdout.write('✗'); }

    if (results.length % 60 === 0) process.stdout.write('\n');
  }

  process.stdout.write('\n\n');

  mkdirSync('data', { recursive: true });

  const output: UrlData = {
    fetched_at: new Date().toISOString(),
    total: songs.length,
    exact,
    fuzzy,
    none,
    results,
  };

  writeFileSync('data/apple-music-urls.json', JSON.stringify(output, null, 2), 'utf-8');

  console.log(`Results:  ✓ ${exact} exact  ~ ${fuzzy} fuzzy  ✗ ${none} none`);
  console.log(`Written to data/apple-music-urls.json`);
  if (fuzzy > 0) {
    console.log(`\nReview fuzzy matches before running npm run apply:apple-music-urls`);
  }

  await pool.end();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
