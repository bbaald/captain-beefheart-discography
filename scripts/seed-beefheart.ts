/**
 * scripts/seed-beefheart.ts
 *
 * Reads data/beefheart.json (produced by scrape-beefheart.ts) and inserts
 * albums, songs, personnel, and relationships into the database.
 *
 * Idempotent: re-running skips rows that already exist.
 *
 * Usage:  npx tsx scripts/seed-beefheart.ts
 */

import 'dotenv/config';
import { readFileSync } from 'fs';
import { pool } from '../src/db/client';
import type { AlbumEntry, ScrapedData } from './scrape-beefheart';

// ─── Helpers ─────────────────────────────────────────────────────────────────

/** "John French" → "French, John" */
function toSortName(name: string): string {
  const parts = name.trim().split(/\s+/);
  if (parts.length < 2) return name;
  const last = parts[parts.length - 1];
  const first = parts.slice(0, -1).join(' ');
  return `${last}, ${first}`;
}

async function ensureArtist(): Promise<string> {
  const { rows } = await pool.query('SELECT id FROM artists LIMIT 1');
  if (rows.length) {
    console.log(`  Artist: existing (${rows[0].id})`);
    return rows[0].id;
  }
  const { rows: r } = await pool.query(
    `INSERT INTO artists (name, aliases) VALUES ($1, $2) RETURNING id`,
    ['Captain Beefheart', ['Don Van Vliet']],
  );
  console.log(`  Artist: created (${r[0].id})`);
  return r[0].id;
}

/** Returns [id, created] */
async function upsertPersonnel(name: string): Promise<[string, boolean]> {
  const { rows } = await pool.query('SELECT id FROM personnel WHERE name = $1', [name]);
  if (rows.length) return [rows[0].id, false];
  const { rows: r } = await pool.query(
    'INSERT INTO personnel (name, sort_name) VALUES ($1, $2) RETURNING id',
    [name, toSortName(name)],
  );
  return [r[0].id, true];
}

/** Returns [id, created] */
async function upsertSong(
  title: string,
  recordingType: string,
  releaseYear: number | null,
  artistId: string,
): Promise<[string, boolean]> {
  const { rows } = await pool.query(
    `SELECT id FROM songs WHERE LOWER(title) = LOWER($1) AND recording_type = $2`,
    [title, recordingType],
  );
  if (rows.length) return [rows[0].id, false];
  const { rows: r } = await pool.query(
    `INSERT INTO songs (artist_id, title, media_type, recording_type, release_year, credited_as)
     VALUES ($1, $2, 'audio', $3, $4, $5) RETURNING id`,
    [artistId, title, recordingType, releaseYear, 'Captain Beefheart and His Magic Band'],
  );
  return [r[0].id, true];
}

// ─── Album seeder ─────────────────────────────────────────────────────────────

async function seedAlbum(album: AlbumEntry, artistId: string): Promise<{
  albumCreated: boolean;
  songsCreated: number;
  songsReused: number;
  personnelCreated: number;
  creditsCreated: number;
}> {
  const stats = { albumCreated: false, songsCreated: 0, songsReused: 0, personnelCreated: 0, creditsCreated: 0 };

  // ── Album ──
  const { rows: existAlbum } = await pool.query(
    `SELECT id FROM albums WHERE LOWER(title) = LOWER($1)`,
    [album.title],
  );

  let albumId: string;
  if (existAlbum.length) {
    albumId = existAlbum[0].id;
  } else {
    const { rows: r } = await pool.query(
      `INSERT INTO albums (artist_id, title, credited_as, album_type, release_year, cover_art_url)
       VALUES ($1, $2, $3, $4, $5, $6) RETURNING id`,
      [
        artistId,
        album.title,
        'Captain Beefheart and His Magic Band',
        album.album_type,
        album.release_year,
        album.cover_art_url,
      ],
    );
    albumId = r[0].id;
    stats.albumCreated = true;
  }

  // ── Personnel (album-level) ──
  const personnelIds: string[] = [];
  for (const musician of album.musicians) {
    const name = musician.name.trim();
    if (!name || name.length < 2) continue;
    const [pid, created] = await upsertPersonnel(name);
    personnelIds.push(pid);
    if (created) stats.personnelCreated++;
  }

  // ── Songs + relationships ──
  for (const track of album.tracks) {
    const title = track.title.trim();
    if (!title) continue;

    const [songId, created] = await upsertSong(title, album.recording_type, album.release_year, artistId);
    if (created) stats.songsCreated++;
    else stats.songsReused++;

    // song → album
    await pool.query(
      `INSERT INTO song_albums (song_id, album_id, sequence_number)
       VALUES ($1, $2, $3)
       ON CONFLICT (song_id, album_id) DO NOTHING`,
      [songId, albumId, track.sequence],
    );

    // song → personnel (role = 'musician')
    for (const pid of personnelIds) {
      const { rows: existCredit } = await pool.query(
        `SELECT 1 FROM song_personnel
         WHERE song_id = $1 AND personnel_id = $2 AND role = 'musician'`,
        [songId, pid],
      );
      if (!existCredit.length) {
        await pool.query(
          `INSERT INTO song_personnel (song_id, personnel_id, role)
           VALUES ($1, $2, 'musician')`,
          [songId, pid],
        );
        stats.creditsCreated++;
      }
    }
  }

  return stats;
}

// ─── Main ─────────────────────────────────────────────────────────────────────

async function main() {
  const raw = readFileSync('data/beefheart.json', 'utf-8');
  const data = JSON.parse(raw) as ScrapedData;

  console.log(`Loaded ${data.albums.length} albums from data/beefheart.json`);
  console.log(`Scraped: ${data.scraped_at}\n`);

  const artistId = await ensureArtist();

  let totalAlbumsCreated = 0;
  let totalSongsCreated = 0;
  let totalSongsReused = 0;
  let totalPersonnelCreated = 0;
  let totalCreditsCreated = 0;
  let skipped = 0;

  for (const album of data.albums) {
    if (album.tracks.length === 0) {
      console.log(`[skip]  ${album.title} — no tracks`);
      skipped++;
      continue;
    }

    const stats = await seedAlbum(album, artistId);

    const flag = stats.albumCreated ? '[+]' : '[=]';
    console.log(
      `${flag} ${album.title} (${album.release_year ?? '?'})` +
        ` — ${album.tracks.length} tracks` +
        (stats.songsCreated ? `, ${stats.songsCreated} new songs` : '') +
        (stats.songsReused ? `, ${stats.songsReused} reused` : '') +
        (stats.personnelCreated ? `, ${stats.personnelCreated} new personnel` : ''),
    );

    if (stats.albumCreated) totalAlbumsCreated++;
    totalSongsCreated += stats.songsCreated;
    totalSongsReused += stats.songsReused;
    totalPersonnelCreated += stats.personnelCreated;
    totalCreditsCreated += stats.creditsCreated;
  }

  console.log('\n─────────────────────────────────────────');
  console.log(`Albums:    ${totalAlbumsCreated} created, ${data.albums.length - totalAlbumsCreated - skipped} already existed, ${skipped} skipped`);
  console.log(`Songs:     ${totalSongsCreated} created, ${totalSongsReused} reused`);
  console.log(`Personnel: ${totalPersonnelCreated} created`);
  console.log(`Credits:   ${totalCreditsCreated} created`);

  await pool.end();
}

main().catch(err => {
  console.error(err);
  process.exit(1);
});
