# Decisions

Record durable decisions future sprints must respect.

---

## Decision Log

| Date | Decision | Reason | Impact |
|---|---|---|---|
| 2026-05-25 | Project scaffold created using 120x Architect / Builder methodology. | Consistent delivery system. | All work follows sprint-based planning. |
| 2026-05-25 | Database: PostgreSQL. | Specified in proposal. | All schema and query work targets PostgreSQL. |
| 2026-05-25 | API: TypeScript + Node.js + Express. | Specified in proposal. | No Python or other runtimes for API layer. |
| 2026-05-25 | UI: React + Tailwind CSS. | Specified in proposal. | No Vue, Angular, or other UI frameworks. |
| 2026-05-25 | Songs can be audio OR video recordings. | Domain requirement from proposal. | `media_type` field required on every song record. |
| 2026-05-25 | Songs can be studio OR live recordings. | Domain requirement from proposal. | `recording_type` field required on every song record. |
| 2026-05-25 | A song may appear on multiple albums with a per-album sequence number. | Domain requirement — compilations and reissues are common. | Song-Album join table required with `sequence_number` column. |
| 2026-05-25 | Priority tiers for field population are tracked in `docs/DATA_MODEL.md`, not enforced at DB level. | Priorities guide ingestion order, not schema constraints. | Schema should not reject lower-priority nulls. |
| 2026-05-25 | Client is the project owner (personal project). | Confirmed by client. | No external stakeholder approvals required; owner makes all scope decisions. |
| 2026-05-25 | Single artist scope — one real-world entity performing under various names. | Confirmed by client. | `artists` table has one canonical row; aliases stored in `aliases TEXT[]`; each song/album carries a `credited_as` field for the name used on that release. |
| 2026-05-25 | Artist is a first-class DB entity (table), not a string field on Song. | Required to model multiple performance names and maintain a single canonical identity. | `artists` table exists; all songs and albums carry `artist_id` FK. |
| 2026-05-25 | Data ingestion method: scraping. | Confirmed by client. | No manual entry UI or spreadsheet import required. Ingestion tooling is post-coding; sample data for testing may be hand-entered earlier. |
| 2026-05-25 | Recording URLs point to Apple Music or YouTube. | Confirmed by client. | `recording_url` on `songs` stores an Apple Music or YouTube URL. No internal audio storage. |
| 2026-05-25 | Cover art stored as external URL, not DB binary. | Architecture preference confirmed. | `cover_art_url TEXT` on songs and albums. No binary/blob columns. |
| 2026-05-25 | Auth: multiple API keys. Each consumer (scraper, admin UI, MCP server) gets its own key. | Allows per-consumer revocation without rotating all credentials. | `api_keys` table required. Keys stored as hashes (never plaintext). Raw key shown once at creation. Write endpoints require a valid, non-revoked key in `Authorization: Bearer` header. GET endpoints are public. |
| 2026-05-25 | MCP transport: HTTP/SSE. | The database and API server are remote relative to MCP consumers; stdio requires a local process and is not viable. | MCP server exposes an HTTP endpoint; MCP clients connect over the network. The MCP server runs on the same host as the API. |
| 2026-05-25 | MCP server mounted inside the existing Express app at `/mcp`. | Single process, single port, one deployment unit. No operational complexity of a separate process. | `GET /mcp/sse` (SSE endpoint), `POST /mcp/messages` (client→server messages). Implemented in `src/mcp/`. |
| 2026-05-25 | Bootstrap key via seed script (`npm run seed:key`), not env var. | No special-case code in auth middleware; script lives in `scripts/` directory. | Run once against a fresh database before first API use. |
| 2026-05-25 | Custom SQL migration runner (`scripts/migrate.ts`) instead of `node-pg-migrate`. | Simpler, fully transparent — reads numbered `.sql` files from `src/db/migrations/` in order, tracks runs in `_migrations` table. No extra dependency. | Run with `npm run migrate`. Same effect as node-pg-migrate but no third-party migration API to learn. |
| 2026-05-26 | Recording URLs source: iTunes Search API (public, no auth). YouTube deferred to a later sprint. | Apple Developer account not available; iTunes Search API (`itunes.apple.com/search`) is unauthenticated and returns Apple Music `trackViewUrl` links. | Sprint 007 implements search + apply scripts. No credentials required. |
| 2026-05-26 | Admin UI is a separate protected section (`/admin/*`) inside the existing React app, not a separate app or deployment. | Confirmed by client. | API key stored in `sessionStorage`. Public routes remain fully public. No separate build or port. |
