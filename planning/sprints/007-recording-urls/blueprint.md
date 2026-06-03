# Sprint 007 Blueprint — Recording URLs

## Architecture

Two scripts, same two-phase pattern as Sprint 006.

```
scripts/
  fetch-apple-music-urls.ts   ← Phase 1: search → JSON
  apply-apple-music-urls.ts   ← Phase 2: JSON → DB
data/
  apple-music-urls.json       ← output of phase 1 (gitignored)
```

---

## API

Uses the **iTunes Search API** — fully public, no authentication, no Apple
Developer account required.

```
GET https://itunes.apple.com/search
  ?term=<title>+captain+beefheart
  &media=music
  &entity=song
  &limit=5
```

Relevant response fields per result:
- `trackName` — song title on Apple Music
- `artistName` — artist name
- `collectionName` — album name
- `trackViewUrl` — Apple Music link (e.g. `https://music.apple.com/us/album/...`)

No env vars, no credentials, no setup required.

---

## Phase 1 — `fetch-apple-music-urls.ts`

For each song in the DB (`SELECT id, title FROM songs ORDER BY title`):

1. Call iTunes Search API with `term=<title>+captain+beefheart`.
2. Take the top result (first in `results` array).
3. Normalise both the DB title and `trackName` from the response:
   - lowercase, strip punctuation, collapse whitespace
4. Assign confidence:
   - `'exact'` — normalised strings are identical
   - `'fuzzy'` — one is a substring of the other, or edit distance ≤ 2
   - `'none'` — empty results array, or no result passes the fuzzy threshold
5. Record `{ song_id, title, apple_music_url, apple_music_title, confidence }`.
6. Sleep 250 ms between requests (polite; iTunes API has no published rate limit).

### Output shape (`data/apple-music-urls.json`)

```json
{
  "fetched_at": "2026-...",
  "total": 228,
  "exact": 180,
  "fuzzy": 20,
  "none": 28,
  "results": [
    {
      "song_id": "uuid",
      "title": "Electricity",
      "apple_music_title": "Electricity",
      "apple_music_url": "https://music.apple.com/us/album/electricity/...",
      "confidence": "exact"
    }
  ]
}
```

---

## Phase 2 — `apply-apple-music-urls.ts`

- Read `data/apple-music-urls.json`.
- For each result where `confidence === 'exact'`:
  - `UPDATE songs SET recording_url = $1 WHERE id = $2 AND recording_url IS NULL`
  - Skip if URL already set (idempotent).
- Print summary: exact applied, fuzzy skipped, none skipped, already-had-url skipped.

---

## npm scripts (package.json additions)

```json
"search:apple-music": "tsx scripts/fetch-apple-music-urls.ts",
"apply:apple-music-urls": "tsx scripts/apply-apple-music-urls.ts"
```

---

## No new env vars required

The iTunes Search API is unauthenticated. No additions to `.env` or
`.env.example` needed.

---

## Error handling

- Non-200 from iTunes API → log and record `confidence: 'none'`, continue
- Empty `results` array → `confidence: 'none'`
- Network error on single song → log, record `confidence: 'none'`, continue
- Unexpected JSON shape → log warning, record `confidence: 'none'`, continue
