# Sprint 002 Acceptance Criteria

This sprint is complete when:

## Project setup
- [ ] TypeScript project compiles without errors (`tsc --noEmit` passes).
- [ ] `.env.example` documents all required environment variables.
- [ ] `npm run dev` starts the server against a local PostgreSQL instance.

## Database
- [ ] All migrations in `src/db/migrations/` run cleanly on a fresh database.
- [ ] All 7 tables exist with correct columns, types, constraints, and indexes.
- [ ] CHECK constraints reject invalid `media_type`, `recording_type`, and `role` values at the DB level.
- [ ] `UNIQUE (album_id, sequence_number)` constraint exists on `song_albums`.

## Auth
- [ ] `POST /admin/api-keys` creates a key and returns the raw key exactly once.
- [ ] `GET /admin/api-keys` returns key list (no raw key or hash in response).
- [ ] `DELETE /admin/api-keys/:id` revokes a key (sets `revoked_at`).
- [ ] A revoked key is rejected with 401.
- [ ] An unknown key is rejected with 401.
- [ ] A valid key allows write access.
- [ ] First-run bootstrapping is documented (no chicken-and-egg lockout).

## Artist CRUD
- [ ] `GET /api/v1/artists` returns all artists.
- [ ] `GET /api/v1/artists/:id` returns a single artist or 404.
- [ ] `POST /api/v1/artists` creates an artist; returns 201 with the new record.
- [ ] `PATCH /api/v1/artists/:id` updates fields; returns updated record.
- [ ] `DELETE /api/v1/artists/:id` deletes artist or returns 409 if referenced.

## Album CRUD
- [ ] `GET /api/v1/albums` returns all albums.
- [ ] `GET /api/v1/albums/:id` returns a single album or 404.
- [ ] `POST /api/v1/albums` creates an album; returns 201.
- [ ] `PATCH /api/v1/albums/:id` updates album.
- [ ] `DELETE /api/v1/albums/:id` deletes album or returns 409 if referenced.

## Song CRUD
- [ ] `GET /api/v1/songs` returns all songs.
- [ ] `GET /api/v1/songs/:id` returns a single song or 404.
- [ ] `POST /api/v1/songs` with all Priority 1 fields creates a song; returns 201.
- [ ] `POST /api/v1/songs` missing a Priority 1 field returns 422 with field-level error.
- [ ] `PATCH /api/v1/songs/:id` updates song.
- [ ] `DELETE /api/v1/songs/:id` deletes song.

## Tests
- [ ] Auth middleware tests: valid key, invalid key, revoked key.
- [ ] Artist CRUD happy-path tests.
- [ ] Song validation test: missing required field returns 422.
- [ ] All tests pass against a test database (`npm test`).

## Documentation
- [ ] `planning/STATE.md` updated.
- [ ] Any new decisions recorded in `planning/DECISIONS.md`.
