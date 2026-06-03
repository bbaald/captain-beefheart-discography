# Data Model

## Overview

Core entities: `artists`, `songs`, `albums`, `personnel`, `song_albums` (join), `song_personnel` (join).

Priority tiers (from proposal) guide ingestion order; lower-priority fields are nullable and may be populated later.

---

## Priority Reference

| Priority | Fields |
|---|---|
| 1 (required first) | title, artist, media_type, release_date_year, running_time_seconds, songwriters, albums + sequence_number, source_list |
| 2 (populate next) | live_or_studio, musicians, record_label, recording_url |
| 3 (fill in later) | recording_date_year, producers, engineers, lyrics, cover_art_url, liner_notes, catalog_number |

---

## Tables

### `artists`

| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| name | TEXT NOT NULL | Canonical name (the primary identity) |
| sort_name | TEXT | For alphabetical sorting |
| aliases | TEXT[] | Other names this artist performs under |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

The system is scoped to one canonical artist entity. `aliases` captures every performance name (e.g., stage name variants, pseudonyms). Songs and albums carry a `credited_as` field to record which name appeared on that specific release.

---

### `albums`

| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| artist_id | UUID FK → artists | Canonical artist |
| credited_as | TEXT | Artist name as it appears on this release (may differ from canonical name) |
| title | TEXT NOT NULL | |
| album_type | TEXT | 'LP', 'EP', 'Single', 'Compilation', 'Live' |
| release_date | DATE | Nullable — use release_year if only year known |
| release_year | SMALLINT | |
| record_label | TEXT | Priority 2 |
| catalog_number | TEXT | Priority 3 |
| cover_art_url | TEXT | Priority 3 |
| liner_notes | TEXT | Priority 3 |
| source_list | TEXT[] | Array of source references |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

---

### `songs`

| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| title | TEXT NOT NULL | Priority 1 |
| artist_id | UUID FK → artists | Canonical artist. Priority 1 |
| credited_as | TEXT | Artist name as credited on this recording (may differ from canonical name) |
| media_type | TEXT NOT NULL | 'audio' or 'video'. Priority 1 |
| recording_type | TEXT | 'studio' or 'live'. Priority 2 |
| running_time_seconds | INTEGER | Priority 1 |
| release_date | DATE | Nullable |
| release_year | SMALLINT | Priority 1 |
| recording_date | DATE | Nullable. Priority 3 |
| recording_year | SMALLINT | Priority 3 |
| lyrics | TEXT | Priority 3 |
| cover_art_url | TEXT | Priority 3 |
| recording_url | TEXT | Priority 2 — Apple Music or YouTube URL |
| record_label | TEXT | Priority 2 |
| catalog_number | TEXT | Priority 3 |
| liner_notes | TEXT | Priority 3 |
| source_list | TEXT[] | Priority 1 |
| created_at | TIMESTAMPTZ | |
| updated_at | TIMESTAMPTZ | |

---

### `song_albums` (join table)

| Column | Type | Notes |
|---|---|---|
| song_id | UUID FK → songs | |
| album_id | UUID FK → albums | |
| sequence_number | SMALLINT NOT NULL | Track number on this album |
| PRIMARY KEY | (song_id, album_id) | |

---

### `personnel`

| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| name | TEXT NOT NULL | |
| sort_name | TEXT | |
| created_at | TIMESTAMPTZ | |

---

### `api_keys`

| Column | Type | Notes |
|---|---|---|
| id | UUID PK | |
| label | TEXT NOT NULL | Human-readable name for this key (e.g., 'scraper', 'admin-ui', 'mcp-server') |
| key_hash | TEXT NOT NULL UNIQUE | SHA-256 hash of the raw key — plaintext never stored |
| created_at | TIMESTAMPTZ | |
| last_used_at | TIMESTAMPTZ | Updated on each authenticated request |
| revoked_at | TIMESTAMPTZ | NULL = active; non-NULL = revoked |

Raw key is generated at creation time, shown to the user once, and never retrievable again. Revocation is a soft delete via `revoked_at`.

---

### `song_personnel` (join table)

| Column | Type | Notes |
|---|---|---|
| song_id | UUID FK → songs | |
| personnel_id | UUID FK → personnel | |
| role | TEXT NOT NULL | 'musician', 'songwriter', 'producer', 'engineer' |
| instrument | TEXT | Optional: e.g., 'guitar', 'drums' |
| PRIMARY KEY | (song_id, personnel_id, role) | |

---

## Relationships

- Artist → Songs: one-to-many (primary artist).
- Artist → Albums: one-to-many (primary artist).
- Song ↔ Album: many-to-many via `song_albums`.
- Song ↔ Personnel: many-to-many via `song_personnel` with role.

---

## Open

- Collaboration modeling ("feat." credits): guest musicians can be captured via `song_personnel` with role='musician'. True co-billed releases (split albums) are out of scope for now. Revisit in Sprint 002 if needed.
