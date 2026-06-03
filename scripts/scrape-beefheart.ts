/**
 * scripts/scrape-beefheart.ts
 *
 * Scrapes official Captain Beefheart discography from beefheart.com and writes
 * structured data to data/beefheart.json for review before DB seeding.
 *
 * Usage:  npx tsx scripts/scrape-beefheart.ts
 * Output: data/beefheart.json
 */

import { writeFileSync, mkdirSync } from 'fs';
import { load } from 'cheerio';

const BASE = 'https://www.beefheart.com';
const DELAY_MS = 700; // polite delay between requests

// ─── Types ──────────────────────────────────────────────────────────────────

export interface TrackEntry {
  sequence: number;
  title: string;
}

export interface MusicianEntry {
  name: string;
  instruments: string;
}

export interface AlbumEntry {
  title: string;
  album_type: 'LP' | 'Live';
  recording_type: 'studio' | 'live';
  cover_art_url: string | null;
  release_year: number | null;
  recorded: string | null;
  detail_url: string;
  tracks: TrackEntry[];
  musicians: MusicianEntry[];
}

export interface ScrapedData {
  scraped_at: string;
  source: string;
  albums: AlbumEntry[];
}

// ─── Listing pages to process ───────────────────────────────────────────────

const LISTING_PAGES: Array<{
  url: string;
  album_type: 'LP' | 'Live';
  recording_type: 'studio' | 'live';
}> = [
  {
    url: `${BASE}/music/discography/official-captain-beefheart-studio-albums/`,
    album_type: 'LP',
    recording_type: 'studio',
  },
  {
    url: `${BASE}/music/discography/official-captain-beefheart-live-albums/`,
    album_type: 'Live',
    recording_type: 'live',
  },
];

// ─── HTTP helper ─────────────────────────────────────────────────────────────

async function fetchHtml(url: string): Promise<string> {
  const res = await fetch(url, {
    headers: {
      'User-Agent': 'Mozilla/5.0 (compatible; discography-scraper/1.0; +https://github.com/beefheart-discography)',
      Accept: 'text/html,application/xhtml+xml',
    },
  });
  if (!res.ok) throw new Error(`HTTP ${res.status} fetching ${url}`);
  return res.text();
}

function sleep(ms: number) {
  return new Promise<void>(resolve => setTimeout(resolve, ms));
}

// ─── Listing page parser ─────────────────────────────────────────────────────

/**
 * The listing pages share a consistent structure inside `.entry-the-content`:
 *
 *   H2                   ← album title
 *   P.apply-lightbox     ← cover art img + blurb
 *   P                    ← "Recorded: YYYY\nReleased: YYYY\nSee full…" + detail link
 *   H2                   ← next album title …
 */
function parseListingPage(
  html: string,
  albumType: 'LP' | 'Live',
  recordingType: 'studio' | 'live',
): AlbumEntry[] {
  const $ = load(html);
  const content = $('.entry-the-content').first();
  const albums: AlbumEntry[] = [];
  let current: AlbumEntry | null = null;

  content.children().each((_, el) => {
    const tag = (el.type === 'tag' ? el.name : '').toLowerCase();
    const $el = $(el);

    if (tag === 'h2') {
      const title = $el.text().trim();
      if (title) {
        current = {
          title,
          album_type: albumType,
          recording_type: recordingType,
          cover_art_url: null,
          release_year: null,
          recorded: null,
          detail_url: '',
          tracks: [],
          musicians: [],
        };
        albums.push(current);
      }
    } else if (tag === 'p' && current) {
      // Cover art: grab any <img> we find (first one per album wins)
      const imgSrc = $el.find('img').first().attr('src');
      if (imgSrc && !current.cover_art_url) current.cover_art_url = imgSrc;

      // Metadata paragraph: "Recorded: ...\nReleased: ...\nSee full…"
      const text = $el.text();
      if (text.includes('Released:')) {
        const relMatch = text.match(/Released:\s*(\d{4})/);
        const recMatch = text.match(/Recorded:\s*([^\n]+)/);
        if (relMatch) current.release_year = parseInt(relMatch[1], 10);
        if (recMatch) current.recorded = recMatch[1].trim();

        const link = $el.find('a[href]').first();
        const href = link.attr('href') ?? '';
        if (href && !href.startsWith('mailto:')) {
          current.detail_url = href.startsWith('http') ? href : `${BASE}${href}`;
        }
      }
    }
  });

  // Only return albums that have a detail page link
  return albums.filter(a => a.detail_url);
}

// ─── Detail page parser ───────────────────────────────────────────────────────

/**
 * Detail pages have H2-delimited sections. We parse:
 *   H2 "Musicians" → next UL → li items (name – instruments)
 *   H2 "Track list" → next OL → li items (track titles)
 */
function parseDetailPage(html: string): {
  tracks: TrackEntry[];
  musicians: MusicianEntry[];
} {
  const $ = load(html);
  const content = $('.entry-the-content').first();

  const tracks: TrackEntry[] = [];
  const musicians: MusicianEntry[] = [];

  /** Matches section H2 with or without trailing colon, case-insensitive. */
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  function h2Matches(el: any, title: string): boolean {
    const t = $(el).text().trim().replace(/:$/, '');
    return t.toLowerCase() === title.toLowerCase();
  }

  /** Returns the HTML of the first matching list-tag after the named H2, or null. */
  function nextListAfterH2(h2Text: string, listTag: 'ol' | 'ul'): string | null {
    let foundHtml: string | null = null;
    content.find('h2').each((_, h2el) => {
      if (h2Matches(h2el, h2Text)) {
        let next = $(h2el).next();
        while (next.length) {
          const t = next[0].type === 'tag' ? next[0].name.toLowerCase() : '';
          if (t === 'h2') return false; // stop each()
          if (t === listTag) { foundHtml = $.html(next); return false; }
          next = next.next();
        }
      }
    });
    return foundHtml;
  }

  /** Returns the text of the first <p> directly after the named H2, or null. */
  function nextParaAfterH2(h2Text: string): string | null {
    let found: string | null = null;
    content.find('h2').each((_, h2el) => {
      if (h2Matches(h2el, h2Text)) {
        let next = $(h2el).next();
        while (next.length) {
          const t = next[0].type === 'tag' ? next[0].name.toLowerCase() : '';
          if (t === 'h2') return false;
          if (t === 'p') { found = $(next).text(); return false; }
          next = next.next();
        }
      }
    });
    return found;
  }

  /** Parse a musician string like "Name – instruments" or just "Name". */
  function parseMusicianLine(line: string) {
    const sep = line.includes(' – ') ? ' – ' : line.includes(' - ') ? ' - ' : null;
    if (sep) {
      const idx = line.indexOf(sep);
      return { name: line.slice(0, idx).trim(), instruments: line.slice(idx + sep.length).trim() };
    }
    return { name: line.trim(), instruments: '' };
  }

  // ── Track list ────────────────────────────────────────────────────────────
  const olHtml = nextListAfterH2('Track list', 'ol');
  if (olHtml) {
    const $ol = load(olHtml);
    $ol('li').each((i, li) => {
      const title = $ol(li).text().trim();
      if (title) tracks.push({ sequence: i + 1, title });
    });
  }

  // ── Musicians ─────────────────────────────────────────────────────────────
  // Some pages use <ul>, others use a <p> with newline-separated entries.
  const ulHtml = nextListAfterH2('Musicians', 'ul');
  if (ulHtml) {
    const $ul = load(ulHtml);
    $ul('li').each((_, li) => {
      const text = $ul(li).text().trim();
      if (text) musicians.push(parseMusicianLine(text));
    });
  } else {
    // Fallback: multi-line <p> under "Musicians" / "Musicians:"
    const paraText = nextParaAfterH2('Musicians');
    if (paraText) {
      paraText.split('\n').forEach(line => {
        const trimmed = line.trim();
        if (trimmed && trimmed.length > 1) musicians.push(parseMusicianLine(trimmed));
      });
    }
  }

  return { tracks, musicians };
}

// ─── Main ────────────────────────────────────────────────────────────────────

async function main() {
  const allAlbums: AlbumEntry[] = [];

  for (const config of LISTING_PAGES) {
    console.log(`\nFetching listing: ${config.url}`);
    const html = await fetchHtml(config.url);
    const albums = parseListingPage(html, config.album_type, config.recording_type);
    console.log(`  Found ${albums.length} albums`);

    for (const album of albums) {
      console.log(`  → ${album.title} (${album.release_year ?? '?'})`);
      await sleep(DELAY_MS);

      try {
        const detailHtml = await fetchHtml(album.detail_url);
        const detail = parseDetailPage(detailHtml);
        album.tracks = detail.tracks;
        album.musicians = detail.musicians;
        console.log(`     ${detail.tracks.length} tracks, ${detail.musicians.length} musicians`);
      } catch (err) {
        console.error(`     ERROR: ${err}`);
        // Leave empty arrays — seed script skips albums with 0 tracks
      }

      allAlbums.push(album);
    }
  }

  mkdirSync('data', { recursive: true });

  const output: ScrapedData = {
    scraped_at: new Date().toISOString(),
    source: 'https://www.beefheart.com/music/discography/',
    albums: allAlbums,
  };

  writeFileSync('data/beefheart.json', JSON.stringify(output, null, 2), 'utf-8');

  const totalTracks = allAlbums.reduce((n, a) => n + a.tracks.length, 0);
  console.log(`\n✓ Wrote ${allAlbums.length} albums / ${totalTracks} tracks to data/beefheart.json`);
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
