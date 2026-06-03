# REST API

## Base URL

```
/api/v1
```

## Auth

GET endpoints are public. POST, PATCH, and DELETE endpoints require a valid API key.

```
Authorization: Bearer <api-key>
```

The system supports multiple named API keys — one per consumer (e.g., `scraper`, `admin-ui`, `mcp-server`). Keys are stored as SHA-256 hashes; the raw key is shown once at creation and never retrievable. Keys can be revoked individually without affecting others.

### Key management endpoints

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/admin/api-keys` | List keys (label, created_at, last_used_at, revoked_at — no raw key) | Yes |
| POST | `/admin/api-keys` | Create a new key — returns raw key once | Yes |
| DELETE | `/admin/api-keys/:id` | Revoke a key | Yes |

**POST /admin/api-keys** body:

```json
{ "label": "scraper" }
```

Response (raw key shown once):

```json
{
  "id": "uuid",
  "label": "scraper",
  "key": "disc_live_abc123...",
  "created_at": "2026-05-25T00:00:00Z"
}
```

---

## Artists

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/artists` | List all artists | No |
| GET | `/artists/:id` | Get artist with aliases | No |
| POST | `/artists` | Create artist | Yes |
| PATCH | `/artists/:id` | Update artist | Yes |
| DELETE | `/artists/:id` | Delete artist | Yes |

**GET /artists/:id** response includes `aliases` array and summary counts (song count, album count).

---

## Albums

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/albums` | List albums | No |
| GET | `/albums/:id` | Get album with tracklist | No |
| POST | `/albums` | Create album | Yes |
| PATCH | `/albums/:id` | Update album | Yes |
| DELETE | `/albums/:id` | Delete album | Yes |

**Query params for GET /albums:**

| Param | Type | Description |
|---|---|---|
| `artist_id` | UUID | Filter by artist |
| `album_type` | string | 'LP', 'EP', 'Single', 'Compilation', 'Live' |
| `year` | integer | Filter by release_year |
| `sort` | string | 'title', 'release_year' (default: release_year desc) |
| `limit` | integer | Default 50 |
| `offset` | integer | Default 0 |

**GET /albums/:id** response includes full album record and ordered tracklist (songs with sequence_number).

---

## Songs

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/songs` | List / search songs | No |
| GET | `/songs/:id` | Get song with personnel and albums | No |
| POST | `/songs` | Create song | Yes |
| PATCH | `/songs/:id` | Update song | Yes |
| DELETE | `/songs/:id` | Delete song | Yes |

**Query params for GET /songs:**

| Param | Type | Description |
|---|---|---|
| `q` | string | Title search (case-insensitive, partial match) |
| `artist_id` | UUID | Filter by artist |
| `album_id` | UUID | Filter to songs on a specific album |
| `media_type` | string | 'audio' or 'video' |
| `recording_type` | string | 'studio' or 'live' |
| `year` | integer | Filter by release_year |
| `sort` | string | 'title', 'release_year', 'running_time_seconds' |
| `limit` | integer | Default 50 |
| `offset` | integer | Default 0 |

**GET /songs/:id** response includes:
- Full song record
- `albums` — array of albums the song appears on, with sequence_number
- `personnel` — array of credited personnel with role and instrument

---

## Personnel

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/personnel` | List personnel | No |
| GET | `/personnel/:id` | Get person with credited songs | No |
| POST | `/personnel` | Create person | Yes |
| PATCH | `/personnel/:id` | Update person | Yes |
| DELETE | `/personnel/:id` | Delete person | Yes |

---

## Song–Album Relationships

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/songs/:id/albums` | Add song to album | Yes |
| DELETE | `/songs/:id/albums/:albumId` | Remove song from album | Yes |

**POST /songs/:id/albums** body:

```json
{
  "album_id": "uuid",
  "sequence_number": 3
}
```

---

## Song–Personnel Relationships

| Method | Path | Description | Auth |
|---|---|---|---|
| POST | `/songs/:id/personnel` | Add personnel credit to song | Yes |
| DELETE | `/songs/:id/personnel/:personnelId/roles/:role` | Remove a specific role credit | Yes |

**POST /songs/:id/personnel** body:

```json
{
  "personnel_id": "uuid",
  "role": "musician",
  "instrument": "guitar"
}
```

---

## Search

| Method | Path | Description | Auth |
|---|---|---|---|
| GET | `/search` | Cross-entity search across songs and albums | No |

**Query params:**

| Param | Type | Description |
|---|---|---|
| `q` | string | Required. Searches song titles, album titles. |
| `type` | string | Optional: 'song', 'album'. Default: both. |

Response returns ranked results grouped by entity type.

---

## Error Format

All errors return a consistent JSON body:

```json
{
  "error": "human-readable message",
  "code": "MACHINE_READABLE_CODE"
}
```

Standard HTTP status codes: 400 bad request, 401 unauthorized, 404 not found, 409 conflict (duplicate), 422 validation error, 500 server error.

---

## Open

- Auth mechanism (API key vs. session) not yet decided. Confirm before Sprint 002.
- Pagination style (offset vs. cursor) not yet decided. Offset shown above; switch to cursor if data volume warrants.
