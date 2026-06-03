# Sprint 007 Acceptance Criteria — Recording URLs

## Setup

- [ ] `.env` has `APPLE_MUSIC_KEY_ID`, `APPLE_MUSIC_TEAM_ID`, `APPLE_MUSIC_PRIVATE_KEY_PATH`
- [ ] `.env.example` documents those three variables (no values)

## Phase 1 — search

- [ ] `npm run search:apple-music` runs without error
- [ ] `data/apple-music-urls.json` is created
- [ ] JSON contains `total`, `exact`, `fuzzy`, `none` summary counts
- [ ] `results` array has one entry per song in the DB
- [ ] Each entry has `song_id`, `title`, `apple_music_url` (or null), `apple_music_title` (or null), `confidence`
- [ ] `confidence` is one of `'exact'`, `'fuzzy'`, `'none'`
- [ ] Re-running overwrites the file cleanly (no duplicates)

## Phase 2 — apply

- [ ] `npm run apply:apple-music-urls` runs without error
- [ ] Songs with `confidence === 'exact'` have `recording_url` set in the DB
- [ ] Songs with `confidence !== 'exact'` are untouched
- [ ] Songs that already had a URL are not overwritten
- [ ] Re-running is a no-op (idempotent)
- [ ] Output shows counts: applied, skipped-fuzzy, skipped-none, skipped-already-set

## Security

- [ ] No credentials appear in any committed file
- [ ] `data/apple-music-urls.json` is listed in `.gitignore`
