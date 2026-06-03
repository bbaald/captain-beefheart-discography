# Sprint 003 Requirements — Relationships, Search & Personnel

## Goal

Complete the API surface for the core data model: connect songs to albums and personnel, enrich the GET responses for songs and albums with their related data, add filtering to list endpoints, and expose a cross-entity search.

---

## Business Objective

After this sprint, the API is fully usable for real data entry — a song can be placed on an album, credited to its writers and musicians, and found by title search.

---

## In Scope

### Personnel CRUD
- `GET /api/v1/personnel` — list all
- `GET /api/v1/personnel/:id` — single record
- `POST /api/v1/personnel` — create
- `PATCH /api/v1/personnel/:id` — update
- `DELETE /api/v1/personnel/:id` — delete (409 if referenced)

### Song–Album relationship endpoints
- `POST /api/v1/songs/:id/albums` — add song to album with sequence_number
- `DELETE /api/v1/songs/:id/albums/:albumId` — remove song from album

### Song–Personnel relationship endpoints
- `POST /api/v1/songs/:id/personnel` — add a personnel credit (role, optional instrument)
- `DELETE /api/v1/songs/:id/personnel/:personnelId/roles/:role` — remove a specific role credit

### Enhanced GET responses
- `GET /api/v1/songs/:id` — include `albums` array (album record + sequence_number) and `personnel` array (person record + role + instrument)
- `GET /api/v1/albums/:id` — include `songs` array (song record + sequence_number), ordered by sequence_number

### Query params on list endpoints
- `GET /api/v1/songs` — add: `q` (title ILIKE), `media_type`, `recording_type`, `year`, `album_id`, `sort` (title | release_year), `limit` (default 50), `offset` (default 0)
- `GET /api/v1/albums` — add: `album_type`, `year`, `sort` (title | release_year), `limit`, `offset`

### Search
- `GET /api/v1/search?q=&type=` — searches song titles and album titles via ILIKE; results grouped by type

---

## Out of Scope

- Full-text search (`tsvector`) — ILIKE is sufficient for now
- Personnel search
- MCP server
- React UI
- Deployment

---

## Business Rules

- A song may not be added to the same album twice (PK constraint enforces this — return 409).
- A person may not hold the same role on the same song twice (composite PK enforces — return 409).
- `sequence_number` must be unique per album (UNIQUE constraint — return 409 with clear message).
- `role` must be one of: musician, songwriter, producer, engineer.
- Search requires `q` param of at least 1 character; return 400 otherwise.
- `limit` max is 200.
