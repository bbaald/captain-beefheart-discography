# Sprint 002 Requirements — Database Schema + API Skeleton

## Goal

Stand up a working TypeScript/Express API backed by PostgreSQL with the full schema in place, API key auth wired, and CRUD for the three core entities: Artist, Album, Song.

---

## Business Objective

Produce a running, testable API that proves the full stack end-to-end before relationship endpoints and the UI are built.

---

## Users

Project owner (local development and eventual deployment).

---

## In Scope

- TypeScript + Express project initialization and folder structure.
- PostgreSQL connection and migration tooling setup.
- Migrations for all database tables defined in `docs/DATA_MODEL.md`.
- API key auth middleware (hash-and-compare against `api_keys` table).
- Key management endpoints (`GET/POST/DELETE /admin/api-keys`).
- Artist CRUD (`GET/POST/PATCH/DELETE /api/v1/artists`).
- Album CRUD (`GET/POST/PATCH/DELETE /api/v1/albums`).
- Song CRUD (`GET/POST/PATCH/DELETE /api/v1/songs`).
- Request validation with clear error responses.
- Tests for auth middleware and at least one CRUD flow per entity.

---

## Out of Scope

- Song–Album relationship endpoints (`/songs/:id/albums`).
- Song–Personnel relationship endpoints (`/songs/:id/personnel`).
- Personnel CRUD.
- Search endpoint.
- React UI.
- MCP server.
- Deployment / hosting.

---

## Business Rules (from DECISIONS.md)

- `GET` endpoints are public; `POST`, `PATCH`, `DELETE` require a valid, non-revoked API key.
- `GET /admin/api-keys` also requires auth.
- Raw API key is shown once at creation; only the SHA-256 hash is stored.
- `artist_id` on songs and albums is NOT NULL — every record must be owned by a canonical artist.
- `credited_as` on songs and albums is nullable — only set when the credited name differs from the canonical artist name.
- Priority 1 fields (`title`, `artist_id`, `media_type`, `running_time_seconds`, `release_year`, `source_list`) are required at the API layer for song creation.
- `media_type` must be `'audio'` or `'video'`; `recording_type` must be `'studio'`, `'live'`, or null.
