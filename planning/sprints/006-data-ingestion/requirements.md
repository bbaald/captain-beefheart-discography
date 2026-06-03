# Sprint 006 Requirements — Data Ingestion

## Goal

Populate the database with Captain Beefheart's official discography from
`https://www.beefheart.com/music/discography/`.

## In scope

- Official studio albums (14 LPs, listed at `/official-captain-beefheart-studio-albums/`)
- Official live albums (7 releases, listed at `/official-captain-beefheart-live-albums/`)
- Per-album: title, release year, cover art URL, track listing (ordered), musicians

## Out of scope

- Compilations (duplicate studio songs; nothing new)
- Singles (unstructured page; no clean track listing)
- Bootlegs, collaborations, cover versions
- Running times (not available on source site)
- Apple Music / YouTube source URLs (separate sprint)

## Constraints

- Two-phase: scrape → JSON first, seed from JSON second (reviewable, replayable)
- Polite scraping: ≥600 ms delay between requests
- Idempotent seed: re-running does not create duplicates
- No new DB migrations needed
- `recording_type`: 'studio' for LPs, 'live' for live albums
- `media_type`: 'audio' for all songs (default)
- `credited_as`: 'Captain Beefheart and His Magic Band' for all songs/albums
- Artist row: one `artists` record with `name = 'Captain Beefheart'`, `aliases = ['Don Van Vliet']`
