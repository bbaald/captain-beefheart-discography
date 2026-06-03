# Project State

**Project:** Discography Database
**Client:** Project owner (personal project)
**Last updated:** 2026-05-26

---

## Current Status

Sprint 009 — Admin UI **complete**. Protected `/admin` section with full CRUD for albums, songs, personnel, and relationships. Auth gate via sessionStorage API key.

---

## Active Sprint

None.

---

## Recently Completed

- Sprint 009: Admin UI — Protected `/admin` section with login gate, dashboard, and full CRUD.
  - `src/ui/src/lib/adminAuth.ts` — `sessionStorage` key helpers.
  - `src/ui/src/lib/adminApi.ts` — typed fetch wrapper; auto-redirect to `/admin/login` on 401.
  - `src/ui/src/admin/` — `AdminLogin`, `RequireAdminAuth`, `AdminLayout`, `AdminDashboard`.
  - `src/ui/src/admin/{albums,songs,personnel}/` — list + form components for all three entities.
  - `src/ui/src/admin/relationships/` — `AlbumTrackEditor` and `SongPersonnelEditor` inline editors.
  - `src/ui/src/App.tsx` — `/admin/*` routes wired behind `RequireAdminAuth`.
- Sprint 008: MCP Contract Tests — 29 tests for all 6 tools, handlers extracted as named exports for direct testing.
  - `src/mcp/server.ts` — handlers refactored into exported named functions (`searchSongs`, `getSong`, etc.).
  - `tests/mcp.test.ts` — 29 tests covering happy paths, filters, shape assertions, not-found errors.
- Sprint 007: Recording URLs — iTunes Search API, two-phase (fetch → apply), 211/228 songs linked.
  - `scripts/fetch-apple-music-urls.ts` — searches iTunes, writes `data/apple-music-urls.json` with confidence tiers.
  - `scripts/apply-apple-music-urls.ts` — applies exact matches to DB; skips fuzzy/none automatically.
  - 157 exact auto-applied; 54 fuzzy manually promoted (safe variants, live equivalents, stripped titles); 17 not on Apple Music.
- Sprint 006: Data Ingestion — scrape → JSON → seed, two-phase, idempotent.
  - `scripts/scrape-beefheart.ts` — fetches studio + live album listing pages, parses each detail page; writes `data/beefheart.json`.
  - `scripts/seed-beefheart.ts` — idempotent seed from JSON; upserts artist, albums, songs, personnel, and relationship rows.
  - `data/beefheart.json` — 20 albums / 244 tracks scraped from beefheart.com.
  - Result: 19 albums seeded (1 skipped — no tracks), 228 songs created, 16 reused across live albums, 45 personnel, 1049 song-personnel credits.
  - Notes: A&M Sessions and Bat Chain Puller have no musician data on source site. 5 live albums have no musician section. Magneticism skipped (0 tracks on source page).
- Sprint 005: MCP Server — Streamable HTTP transport, 6 read-only tools, direct DB queries.
  - `src/mcp/server.ts` — `createMcpServer()` factory; 6 tools registered via `McpServer.registerTool()`.
  - `src/mcp/router.ts` — Express router with stateful `StreamableHTTPServerTransport` session management.
  - `src/api/index.ts` — MCP router mounted at `/mcp`.
  - `package.json` — `@modelcontextprotocol/sdk ^1.29.0` added; `zod` upgraded to `^3.25.0`.
  - `tsconfig.json` — `src/ui` added to exclude list.
  - `docs/ARCHITECTURE.md` — updated to confirm transport, mount path, and tool list.
- Sprint 004: React UI — Home, Album, Song, Search, Artist pages; Tailwind dark theme; Vite proxy; Express static serving for production.
- Sprint 003: relationships, search, personnel, enriched GETs, list filtering.
- Sprint 002: TypeScript/Express API with full PostgreSQL schema and CRUD.
- Sprint 001: all planning and architecture artifacts produced.

---

## Upcoming Sprints

- **Sprint 007 — Recording URLs**: ✅ **Complete** — 211/228 songs have Apple Music URLs. 17 songs have no URL; all confirmed absent from Apple's catalog (primarily tracks from *Unconditionally Guaranteed* and certain *Trout Mask Replica* deep cuts). See `data/personnel-provenance.md` for provenance notes.
- **Sprint 008 — MCP Contract Tests**: ✅ **Complete** — 29 tests, 67/67 total passing.
- **Sprint 009 — Admin UI**: ✅ **Complete** — Protected `/admin` section inside the existing React app. API key stored in `sessionStorage`. Full CRUD for albums, songs, personnel, and relationships via forms and embedded relationship editors.

---

## Blockers

None.
