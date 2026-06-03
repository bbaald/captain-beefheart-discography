# Sprint 003 Blueprint — Relationships, Search & Personnel

## Objective

Extend the Sprint 002 API with Personnel CRUD, relationship endpoints, enriched GET responses, list filtering, and search.

---

## Files to Review Before Starting

- `AGENTS.md`
- `planning/STATE.md`
- `planning/DECISIONS.md`
- `docs/DATA_MODEL.md`
- `docs/API.md`
- `planning/sprints/003-relationships-search/requirements.md`

---

## Files to Create or Update

| File | Action |
|---|---|
| `src/api/routes/personnel.ts` | Create — Personnel CRUD |
| `src/api/routes/song-albums.ts` | Create — Song–Album relationship endpoints |
| `src/api/routes/song-personnel.ts` | Create — Song–Personnel relationship endpoints |
| `src/api/routes/search.ts` | Create — cross-entity search |
| `src/api/routes/songs.ts` | Update — enhanced GET /:id, add query params to GET / |
| `src/api/routes/albums.ts` | Update — enhanced GET /:id, add query params to GET / |
| `src/api/index.ts` | Update — mount new routers |
| `tests/personnel.test.ts` | Create |
| `tests/song-albums.test.ts` | Create |
| `tests/search.test.ts` | Create |

---

## Implementation Plan

### 1. Personnel CRUD (`src/api/routes/personnel.ts`)

Same pattern as `artists.ts`. Zod schema: `{ name: string, sort_name?: string }`. No `updated_at` column — schema uses only `created_at`. PATCH should return a 400 attempting to update `created_at` (just don't expose it as a patchable field). Hard delete returns 409 on FK violation.

### 2. Song–Album relationships (`src/api/routes/song-albums.ts`)

Mount on `router` and attach via `app.use('/api/v1/songs', songAlbumsRouter)` alongside the existing songs router — Express allows multiple routers on the same path prefix.

**POST /api/v1/songs/:id/albums**

Zod body: `{ album_id: uuid, sequence_number: integer (1–999) }`.

Insert into `song_albums`. Map constraint violations:
- `23503` (FK) → 404 with message indicating which FK failed (song or album not found)
- `23505` (unique violation on album_id + sequence_number) → 409 "That track number is already taken on this album"
- `23505` (unique violation on song_id + album_id PK) → 409 "Song is already on this album"

Return 201 with `{ song_id, album_id, sequence_number }`.

**DELETE /api/v1/songs/:id/albums/:albumId**

Delete from `song_albums` where `song_id = $1 AND album_id = $2`. Return 204 or 404.

### 3. Song–Personnel relationships (`src/api/routes/song-personnel.ts`)

**POST /api/v1/songs/:id/personnel**

Zod body: `{ personnel_id: uuid, role: enum, instrument?: string }`.

Insert into `song_personnel`. Map constraint violations:
- `23503` → 404
- `23505` on composite PK → 409 "This person already holds that role on this song"

Return 201 with `{ song_id, personnel_id, role, instrument }`.

**DELETE /api/v1/songs/:id/personnel/:personnelId/roles/:role**

Validate `role` is a known value before querying. Delete from `song_personnel` where all three match. Return 204 or 404.

### 4. Enhanced GET /songs/:id

Replace the simple `SELECT * FROM songs WHERE id = $1` with three queries (run in parallel with `Promise.all`):

```sql
-- 1. Song record
SELECT * FROM songs WHERE id = $1;

-- 2. Albums this song appears on
SELECT a.*, sa.sequence_number
FROM song_albums sa
JOIN albums a ON a.id = sa.album_id
WHERE sa.song_id = $1
ORDER BY a.release_year NULLS LAST, a.title;

-- 3. Personnel credited on this song
SELECT p.*, sp.role, sp.instrument
FROM song_personnel sp
JOIN personnel p ON p.id = sp.personnel_id
WHERE sp.song_id = $1
ORDER BY sp.role, p.name;
```

Response shape:
```json
{
  ...songFields,
  "albums": [{ ...albumFields, "sequence_number": 1 }],
  "personnel": [{ ...personFields, "role": "songwriter", "instrument": null }]
}
```

### 5. Enhanced GET /albums/:id

Two queries (parallel):

```sql
-- 1. Album record
SELECT * FROM albums WHERE id = $1;

-- 2. Tracklist
SELECT s.*, sa.sequence_number
FROM song_albums sa
JOIN songs s ON s.id = sa.song_id
WHERE sa.album_id = $1
ORDER BY sa.sequence_number;
```

Response shape:
```json
{
  ...albumFields,
  "songs": [{ ...songFields, "sequence_number": 1 }]
}
```

### 6. Query params on GET /songs

Build a dynamic WHERE clause. Sanitise by whitelisting allowed `sort` values and capping `limit`.

```
q           → WHERE title ILIKE '%' || $n || '%'
media_type  → WHERE media_type = $n
recording_type → WHERE recording_type = $n
year        → WHERE release_year = $n
album_id    → WHERE id IN (SELECT song_id FROM song_albums WHERE album_id = $n)
sort        → ORDER BY {title|release_year} (default: release_year DESC NULLS LAST, title)
limit       → LIMIT (min 1, max 200, default 50)
offset      → OFFSET (default 0)
```

### 7. Query params on GET /albums

```
album_type  → WHERE album_type = $n
year        → WHERE release_year = $n
sort        → ORDER BY {title|release_year} (default: release_year DESC NULLS LAST, title)
limit / offset → same as songs
```

### 8. Search (`src/api/routes/search.ts`)

Require `q` param (min length 1); return 400 if missing or empty.
Optional `type` param: `'song'` | `'album'` | omitted (both).

```sql
SELECT 'song'  AS type, id, title AS name, release_year FROM songs  WHERE title ILIKE '%' || $1 || '%'
UNION ALL
SELECT 'album' AS type, id, title AS name, release_year FROM albums WHERE title ILIKE '%' || $1 || '%'
ORDER BY type, name;
```

When `type` is specified, omit the other branch from the UNION.

Response:
```json
{
  "query": "blue",
  "results": {
    "songs":  [{ "id": "...", "name": "Blue Song", "release_year": 2001 }],
    "albums": [{ "id": "...", "name": "Blue Album", "release_year": 2003 }]
  }
}
```

### 9. Tests

- `tests/personnel.test.ts` — CRUD happy paths (same pattern as `artists.test.ts`)
- `tests/song-albums.test.ts` — add song to album, duplicate returns 409, sequence conflict returns 409, remove song from album
- `tests/search.test.ts` — returns matching songs and albums, missing `q` returns 400, `type` filter works

### 10. Update planning

- Update `planning/STATE.md`.
- Add any new decisions to `planning/DECISIONS.md`.

---

## Notes

- Do not add full-text search (`tsvector`) in this sprint — ILIKE is sufficient.
- Do not implement MCP server — deferred.
- Do not implement the React UI — later sprint.
- `personnel` has no `updated_at` column — do not add one; PATCH rebuilds only `name` and `sort_name`.
