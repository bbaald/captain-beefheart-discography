# Sprint 002 Blueprint — Database Schema + API Skeleton

## Objective

A running Express API with full PostgreSQL schema, auth middleware, and CRUD for Artist, Album, Song.

---

## Files to Review Before Starting

- `AGENTS.md`
- `planning/STATE.md`
- `planning/DECISIONS.md`
- `docs/DATA_MODEL.md`
- `docs/API.md`
- `docs/ARCHITECTURE.md`
- `planning/sprints/002-db-schema-api-skeleton/requirements.md`

---

## Key Technical Decisions

| Choice | Decision | Reason |
|---|---|---|
| DB driver | `pg` (node-postgres) | Standard, well-tested PostgreSQL driver for Node.js |
| Migrations | `node-pg-migrate` | PostgreSQL-specific, SQL-based, lightweight |
| Validation | `zod` | TypeScript-native schema validation; consistent error shapes |
| Key hashing | `crypto.createHash('sha256')` (Node built-in) | No extra dependency; fast enough for key comparison |
| TypeScript | strict mode | Catch type errors early |

---

## Folder Structure

```text
src/
├── api/
│   ├── routes/
│   │   ├── artists.ts
│   │   ├── albums.ts
│   │   ├── songs.ts
│   │   └── admin.ts
│   ├── middleware/
│   │   └── auth.ts
│   └── index.ts          # Express app (no listen — for testability)
├── db/
│   ├── client.ts         # pg Pool setup
│   └── migrations/       # node-pg-migrate SQL files
├── types/
│   └── index.ts          # Shared TypeScript types
└── server.ts             # Entry point — calls app.listen
```

---

## Implementation Steps

### 1. Project initialization

- `npm init -y`
- Install runtime deps: `express`, `pg`, `node-pg-migrate`, `zod`, `dotenv`
- Install dev deps: `typescript`, `@types/express`, `@types/pg`, `@types/node`, `ts-node`, `tsx`, `vitest`
- Create `tsconfig.json` (strict, target ES2022, module CommonJS)
- Create `.env.example` with `DATABASE_URL`, `PORT`
- Add `.env` to `.gitignore`

### 2. Database connection

- `src/db/client.ts` — exports a `pg.Pool` using `DATABASE_URL` from env
- Connection tested at startup; server exits on failure

### 3. Migrations

Create one migration per logical group (run in order):

| File | Tables |
|---|---|
| `001_create_artists.sql` | `artists` |
| `002_create_albums.sql` | `albums` |
| `003_create_songs.sql` | `songs` |
| `004_create_song_albums.sql` | `song_albums` |
| `005_create_personnel.sql` | `personnel`, `song_personnel` |
| `006_create_api_keys.sql` | `api_keys` |

Include all CHECK constraints, NOT NULL constraints, FK constraints, and indexes documented in `docs/DATA_MODEL.md` and `docs/VALIDATION.md`.

Notable constraints to include:
- `CHECK (media_type IN ('audio', 'video'))` on `songs`
- `CHECK (recording_type IN ('studio', 'live'))` on `songs`
- `UNIQUE (album_id, sequence_number)` on `song_albums`
- `CHECK (role IN ('musician', 'songwriter', 'producer', 'engineer'))` on `song_personnel`

### 4. Auth middleware

`src/api/middleware/auth.ts`:
- Extract `Authorization: Bearer <key>` header
- `crypto.createHash('sha256').update(key).digest('hex')`
- Query `api_keys` where `key_hash = $1 AND revoked_at IS NULL`
- On match: update `last_used_at`, call `next()`
- On no match or missing header: return `401 { error: 'Unauthorized', code: 'INVALID_API_KEY' }`

### 5. Key management endpoints (`/admin/api-keys`)

- `GET /admin/api-keys` — auth required. Return all keys (no hash, no raw key).
- `POST /admin/api-keys` — auth required. Accept `{ label }`. Generate a random 32-byte key (`crypto.randomBytes`), prefix with `disc_`, hash it, insert row, return raw key once.
- `DELETE /admin/api-keys/:id` — auth required. Set `revoked_at = NOW()`.

Bootstrapping: on first run with no keys in DB, the server logs a one-time setup key to stdout (or accept a `BOOTSTRAP_KEY` env var). Document in README.

### 6. Artist routes (`/api/v1/artists`)

- `GET /artists` — list all. No filter params needed in Sprint 002.
- `GET /artists/:id` — single record.
- `POST /artists` — validate with zod: `{ name: string, sort_name?: string, aliases?: string[] }`.
- `PATCH /artists/:id` — partial update; same fields.
- `DELETE /artists/:id` — hard delete (no songs/albums may reference it; return 409 if FK violation).

### 7. Album routes (`/api/v1/albums`)

- `GET /albums` — list all. No filter params in Sprint 002.
- `GET /albums/:id` — single record (no tracklist yet — Sprint 003).
- `POST /albums` — validate: `{ artist_id, title, album_type?, release_year?, credited_as?, source_list? }`.
- `PATCH /albums/:id` — partial update.
- `DELETE /albums/:id` — hard delete (return 409 if FK violation).

### 8. Song routes (`/api/v1/songs`)

- `GET /songs` — list all. No filter params in Sprint 002.
- `GET /songs/:id` — single record (no personnel/albums yet — Sprint 003).
- `POST /songs` — validate Priority 1 fields: `{ title, artist_id, media_type, running_time_seconds, release_year, source_list }` required; all others optional.
- `PATCH /songs/:id` — partial update.
- `DELETE /songs/:id` — hard delete.

### 9. Tests

Use `vitest`. Test files live in `tests/`.

Required coverage:
- Auth middleware: valid key passes, invalid key returns 401, revoked key returns 401.
- Artist CRUD: create, read, update, delete happy paths.
- Song validation: missing Priority 1 field returns 422.

Use a test database (separate `DATABASE_URL_TEST` env var). Run migrations in test setup.

### 10. Update planning

- Add any new decisions to `planning/DECISIONS.md`.
- Update `planning/STATE.md`.

---

## Notes

- Do not implement filter/search query params on list endpoints yet — Sprint 003.
- Do not implement relationship endpoints yet — Sprint 003.
- Do not implement the React UI — later sprint.
- Keep controllers thin: validation in zod schemas, DB queries in route files for now (no separate service layer until complexity warrants it).
