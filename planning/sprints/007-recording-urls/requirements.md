# Sprint 007 Requirements — Recording URLs

## Goal

Populate `songs.recording_url` with Apple Music links for every song in the
database, using the iTunes Search API.

## In scope

- Script to search Apple Music for each song by title + artist and write
  results to a reviewable JSON file (`data/apple-music-urls.json`)
- Script to apply the JSON results to the database (idempotent, skips songs
  that already have a URL)
- Confidence-based auto-apply: only songs with an exact title match (after
  normalisation) are written automatically; near-matches are flagged for
  manual review
- npm scripts: `search:apple-music` and `apply:apple-music-urls`

## Out of scope

- YouTube URLs (separate future sprint)
- UI for browsing/editing URLs
- Handling compilation or live-only tracks that Apple Music may not carry
- Video recordings (`media_type = 'video'`)

## Constraints

- Uses the iTunes Search API (`itunes.apple.com/search`) — no Apple Developer
  account, no credentials, no setup required
- Polite rate limiting: ≥ 250 ms delay between requests
- Two-phase: search → JSON review → apply (same pattern as Sprint 006)
- Idempotent apply: re-running does not overwrite existing URLs
- No new runtime dependencies

## Acceptance criteria

- `npm run search:apple-music` produces `data/apple-music-urls.json` with one
  entry per song containing: `song_id`, `title`, `apple_music_url`,
  `confidence` ('exact' | 'fuzzy' | 'none'), `apple_music_title`
- `npm run apply:apple-music-urls` updates `songs.recording_url` for all
  'exact' matches; skips 'fuzzy' and 'none'; prints a summary
- Re-running apply is a no-op (songs that already have a URL are not
  overwritten)
- `data/apple-music-urls.json` is listed in `.gitignore`
