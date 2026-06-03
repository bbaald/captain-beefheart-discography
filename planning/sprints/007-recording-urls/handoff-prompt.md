# Sprint 007 Handoff Prompt — Recording URLs

You are the Builder for the Discography Database project. Read `AGENTS.md`
first, then `planning/STATE.md`, then this sprint's files in
`planning/sprints/007-recording-urls/`.

## Your task

Implement two scripts that populate `songs.recording_url` with Apple Music
links, using the public iTunes Search API (no credentials required).

## Key files to read before writing any code

- `planning/sprints/007-recording-urls/requirements.md`
- `planning/sprints/007-recording-urls/blueprint.md`
- `planning/sprints/007-recording-urls/acceptance.md`
- `src/db/migrations/003_create_songs.sql` (schema reference)
- `scripts/scrape-beefheart.ts` (pattern reference for two-phase scripts)

## Deliver

1. `scripts/fetch-apple-music-urls.ts`
2. `scripts/apply-apple-music-urls.ts`
3. `package.json` — add `search:apple-music` and `apply:apple-music-urls` scripts
4. `.gitignore` — add `data/apple-music-urls.json`
5. Update `planning/STATE.md`

## Constraints

- iTunes Search API only — `https://itunes.apple.com/search`
- No new runtime dependencies (Node built-in `fetch` is sufficient)
- No credentials or env vars needed
- Polite: 250 ms delay between API requests
- Two-phase, idempotent apply — same discipline as the beefheart scraper
