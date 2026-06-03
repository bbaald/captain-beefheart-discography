/**
 * scripts/fetch-album-artwork.ts
 *
 * Searches the iTunes Search API for every album in the database and writes
 * match results to data/album-artwork.json for review before applying.
 *
 * Usage:  npm run fetch:album-artwork
 * Output: data/album-artwork.json
 */

import 'dotenv/config';
import { writeFileSync, mkdirSync } from 'fs';
import { pool } from '../src/db/client';

const ITUNES_SEARCH   = 'https://itunes.apple.com/search';
const DELAY_MS        = 700;
const RETRY_DELAY_MS  = 8000;

interface ArtworkResult {
  album_id:       string;
  title:          string;
  itunes_title:   string | null;
  artwork_url:    string | null;   // 600×600 URL, ready to store
  confidence:     'exact' | 'fuzzy' | 'none';
}

function sleep(ms: number) {
  return new Promise(r => setTimeout(r, ms));
}

/** Swap iTunes 100×100 thumbnail suffix → 600×600 */
function upscaleArtwork(url: string): string {
  return url.replace(/\/\d+x\d+bb\.jpg$/, '/600x600bb.jpg');
}

function normalise(s: string) {
  return s.toLowerCase().replace(/[^a-z0-9\s]/g, '').replace(/\s+/g, ' ').trim();
}

async function searchItunes(
  term: string,
  retried = false,
): Promise<{ collectionName: string; artworkUrl100: string } | null> {
  const url =
    `${ITUNES_SEARCH}?term=${encodeURIComponent(term)}` +
    `&media=music&entity=album&limit=5`;

  const res = await fetch(url);

  if ((res.status === 429 || res.status === 403) && !retried) {
    console.warn(`  Rate limited — backing off ${RETRY_DELAY_MS / 1000}s…`);
    await sleep(RETRY_DELAY_MS);
    return searchItunes(term, true);
  }

  if (!res.ok) return null;

  const data = (await res.json()) as {
    results: Array<{ collectionName: string; artworkUrl100: string }>;
  };

  return data.results[0] ?? null;
}

async function main() {
  const { rows: albums } = await pool.query<{ id: string; title: string }>(
    `SELECT id, title FROM albums ORDER BY title`,
  );

  console.log(`Fetching artwork for ${albums.length} albums…\n`);

  const results: ArtworkResult[] = [];

  for (const album of albums) {
    const searchTerm = `${album.title} captain beefheart`;
    process.stdout.write(`  ${album.title} … `);

    const hit = await searchItunes(searchTerm);
    await sleep(DELAY_MS);

    if (!hit) {
      process.stdout.write('no results\n');
      results.push({
        album_id: album.id, title: album.title,
        itunes_title: null, artwork_url: null, confidence: 'none',
      });
      continue;
    }

    const normAlbum = normalise(album.title);
    const normHit   = normalise(hit.collectionName);
    const confidence: 'exact' | 'fuzzy' =
      normAlbum === normHit ? 'exact' : 'fuzzy';

    const artworkUrl = upscaleArtwork(hit.artworkUrl100);
    process.stdout.write(`${confidence} → ${hit.collectionName}\n`);

    results.push({
      album_id:     album.id,
      title:        album.title,
      itunes_title: hit.collectionName,
      artwork_url:  artworkUrl,
      confidence,
    });
  }

  mkdirSync('data', { recursive: true });
  writeFileSync('data/album-artwork.json', JSON.stringify(results, null, 2));

  const exact = results.filter(r => r.confidence === 'exact').length;
  const fuzzy = results.filter(r => r.confidence === 'fuzzy').length;
  const none  = results.filter(r => r.confidence === 'none').length;

  console.log(`\nDone. exact: ${exact}  fuzzy: ${fuzzy}  none: ${none}`);
  console.log('Review data/album-artwork.json then run: npm run apply:album-artwork');

  await pool.end();
}

main().catch(e => { console.error(e); process.exit(1); });
