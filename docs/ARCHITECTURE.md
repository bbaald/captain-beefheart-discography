# Architecture

## Overview

The Discography Database is a three-layer system:

1. **PostgreSQL database** — stores all song, album, artist, personnel, and metadata records.
2. **REST API** (TypeScript / Node.js / Express) — exposes CRUD and search over HTTP.
3. **React / Tailwind web UI** — public browsing (routes under `/`) and admin editing (routes under `/admin`).
4. **MCP server** — exposes a set of tools for AI agents to query the discography.

---

## System Components

```text
[Browser / AI Agent]
        │
        ├── HTTP ──► [Express API]  ──► [PostgreSQL]
        │
        └── MCP  ──► [MCP Server]  ──► [Express API or direct DB]
```

---

## Data Flow

1. Editor creates/updates records via Admin UI → API → PostgreSQL.
2. End user searches/browses via Public UI → API → PostgreSQL.
3. AI agent queries via MCP tools → MCP Server → (API or DB) → response.

---

## Key Directories

| Path | Purpose |
|---|---|
| `src/db/` | Database schema, migrations |
| `src/api/` | Express routes, controllers, middleware |
| `src/ui/` | React application (public site + `/admin` section) |
| `src/mcp/` | MCP server |
| `tests/` | Automated tests |
| `scripts/` | Migration runners, seed scripts |

---

## External Services

- PostgreSQL (self-hosted or managed, e.g., Supabase, Railway, Render) — TBD.
- Cover art: stored as external URLs; no binary storage in DB.
- Recording URLs: stored as external URLs (YouTube, Spotify, etc.).

---

---

## MCP Interface

The MCP server exposes read-only tools for AI agents. Write operations go through the REST API.

**Transport:** Streamable HTTP (MCP spec 2025-03-26), mounted inside the existing Express app at `/mcp`.  
**SDK:** `@modelcontextprotocol/sdk` v1.29.0 — `McpServer` + `StreamableHTTPServerTransport`.  
**Session model:** stateful — one `McpServer` + `StreamableHTTPServerTransport` instance per client session, stored in a `Map<sessionId, transport>`. Session ID negotiated via `mcp-session-id` response header on first request.

### Endpoint

All MCP traffic is handled by `POST /mcp` (and `GET /mcp` for SSE streams):
- First POST (no `mcp-session-id` header) → initialize session, transport generates and returns session ID.
- Subsequent POST / GET with `mcp-session-id` → route to existing transport.
- Unknown `mcp-session-id` → 404.

### Tools

| Tool | Inputs | Output |
|---|---|---|
| `search_songs` | `query: string`, `media_type?: 'audio'\|'video'`, `recording_type?: 'studio'\|'live'`, `year?: number` | Array of song summaries (id, title, credited_as, release_year, media_type, recording_type, running_time_seconds) |
| `get_song` | `id: string (UUID)` | Full song record including albums and personnel arrays |
| `list_albums` | `album_type?: string`, `year?: number`, `sort?: string`, `limit?: number`, `offset?: number` | Array of album summaries |
| `get_album` | `id: string (UUID)` | Full album record including ordered tracklist |
| `get_artist` | _(none)_ | Canonical artist record with name, bio, and aliases array |
| `list_personnel` | `song_id: string (UUID)` | Personnel credited on a song with role and instrument |

### Notes

- All tools are read-only. No write tools in this sprint.
- Tools query PostgreSQL directly via `pool.query()` — no HTTP round-trip to the REST layer.
- Invalid UUIDs are caught by Zod schema validation before the handler runs.
- Non-existent IDs return `{ isError: true, content: [{ type: 'text', text: '...' }] }`.
- No auth on MCP tools — consistent with the public read-only API policy.

---

## Architecture Decisions

See `planning/DECISIONS.md`.

## Open

- Hosting environment not yet selected.
