# Sprint 003 Acceptance Criteria

This sprint is complete when:

## Personnel CRUD
- [ ] `GET /api/v1/personnel` returns all personnel.
- [ ] `GET /api/v1/personnel/:id` returns a single record or 404.
- [ ] `POST /api/v1/personnel` creates a person; returns 201.
- [ ] `PATCH /api/v1/personnel/:id` updates name or sort_name; returns updated record.
- [ ] `DELETE /api/v1/personnel/:id` deletes or returns 409 if referenced.

## Song–Album relationships
- [ ] `POST /api/v1/songs/:id/albums` adds a song to an album with sequence_number; returns 201.
- [ ] Duplicate song+album returns 409.
- [ ] Duplicate sequence_number on the same album returns 409 with clear message.
- [ ] `DELETE /api/v1/songs/:id/albums/:albumId` removes the relationship; returns 204 or 404.

## Song–Personnel relationships
- [ ] `POST /api/v1/songs/:id/personnel` adds a credit; returns 201.
- [ ] Duplicate (song + person + role) returns 409.
- [ ] Invalid role value returns 422.
- [ ] `DELETE /api/v1/songs/:id/personnel/:personnelId/roles/:role` removes the credit; returns 204 or 404.

## Enhanced GET responses
- [ ] `GET /api/v1/songs/:id` response includes `albums` and `personnel` arrays.
- [ ] `GET /api/v1/albums/:id` response includes `songs` array ordered by sequence_number.

## Query params
- [ ] `GET /api/v1/songs?q=foo` returns only songs whose title matches (case-insensitive).
- [ ] `GET /api/v1/songs?media_type=video` filters correctly.
- [ ] `GET /api/v1/songs?year=1999` filters correctly.
- [ ] `GET /api/v1/songs?album_id=<uuid>` returns only songs on that album.
- [ ] `GET /api/v1/songs?limit=5&offset=0` paginates correctly.
- [ ] `GET /api/v1/albums?album_type=LP` filters correctly.

## Search
- [ ] `GET /api/v1/search?q=foo` returns matching songs and albums grouped by type.
- [ ] `GET /api/v1/search?q=foo&type=song` returns only song results.
- [ ] `GET /api/v1/search` (no `q`) returns 400.
- [ ] Search is case-insensitive.

## Tests
- [ ] Personnel CRUD happy-path tests pass.
- [ ] Song–Album: add, duplicate-409, sequence-conflict-409, remove tests pass.
- [ ] Search: basic match, type filter, missing-q-400 tests pass.
- [ ] All existing Sprint 002 tests still pass.

## Documentation
- [ ] `planning/STATE.md` updated.
- [ ] Any new decisions recorded in `planning/DECISIONS.md`.
