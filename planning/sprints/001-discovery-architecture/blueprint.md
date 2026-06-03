# Sprint 001 Blueprint — Discovery & Architecture

## Objective

Produce the planning and architecture artifacts needed to begin implementation in Sprint 002.

---

## Files to Review

- `AGENTS.md`
- `planning/STATE.md`
- `planning/DOMAIN.md`
- `planning/QUESTIONS.md`
- `proposal-generic.md`

---

## Files to Create or Update

| File | Action |
|---|---|
| `planning/DOMAIN.md` | Fill in any gaps after client Q&A. |
| `planning/DECISIONS.md` | Add schema and architecture decisions as they are made. |
| `planning/RISKS.md` | Update as risks are resolved or new ones emerge. |
| `planning/QUESTIONS.md` | Answer questions; move answers to DECISIONS.md or DOMAIN.md. |
| `docs/ARCHITECTURE.md` | Draft system component overview. |
| `docs/DATA_MODEL.md` | Draft full PostgreSQL schema with field priorities. |
| `docs/VALIDATION.md` | Draft validation checklist for data integrity. |

---

## Implementation Plan

1. Answer open questions from `planning/QUESTIONS.md` with client.
2. Finalize domain entities: Song, Album, Artist, Personnel, SongAlbum (join), SongPersonnel (join).
3. Write PostgreSQL DDL draft in `docs/DATA_MODEL.md`.
4. Document REST API surface (CRUD for Song, Album, Artist; search endpoints).
5. Document MCP interface sketch (tools: search_songs, get_song, get_album, list_albums).
6. Write architecture overview in `docs/ARCHITECTURE.md`.
7. Write validation approach in `docs/VALIDATION.md`.
8. Update `planning/STATE.md`.

---

## Notes

No production code is created in this sprint unless explicitly approved.
