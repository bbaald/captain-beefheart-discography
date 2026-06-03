# Sprint 005 Requirements — MCP Server (HTTP/SSE)

## Goal

Expose the discography as a set of MCP tools that AI agents can query over the network.

---

## Business Objective

Allow Claude and other MCP-compatible agents to query the discography — search songs, browse albums, look up credits — without going through the REST API manually.

---

## In Scope

- MCP server mounted inside the existing Express app at `/mcp`.
- HTTP/SSE transport: `GET /mcp/sse` and `POST /mcp/messages`.
- Six read-only tools (see below).
- Direct PostgreSQL queries via the existing pool — no HTTP round-trip to the REST API.
- New dependency: `@modelcontextprotocol/sdk`.

### Tools

| Tool | Inputs | Returns |
|---|---|---|
| `search_songs` | `query: string`, `media_type?: 'audio'\|'video'`, `recording_type?: 'studio'\|'live'`, `year?: number` | Array of song summaries |
| `get_song` | `id: string` | Full song record with personnel and albums |
| `list_albums` | `album_type?: string`, `year?: number` | Array of album summaries |
| `get_album` | `id: string` | Full album record with ordered tracklist |
| `get_artist` | *(none — single-artist system)* | Canonical artist with aliases |
| `list_personnel` | `song_id: string` | All credits for a song (role, instrument, name) |

---

## Out of Scope

- Write tools (all MCP tools are read-only).
- MCP auth / API key requirement (read endpoints are public per existing policy).
- MCP tool for personnel browse (not in original sketch).
- Admin UI.

---

## Business Rules

- All tools are read-only — no INSERT, UPDATE, or DELETE.
- Tools query PostgreSQL directly via the shared pool.
- `get_artist` returns the first (and only) artist row — no `id` input needed.
- Tool results are returned as JSON strings in MCP `text` content blocks.
