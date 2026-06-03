# Sprint 005 Acceptance Criteria

This sprint is complete when:

## Setup
- [ ] `@modelcontextprotocol/sdk` is in `package.json` dependencies.
- [ ] `npm install` succeeds.
- [ ] `npm run dev` starts without errors.

## Endpoints
- [ ] `GET /mcp/sse` returns an SSE stream (Content-Type: text/event-stream).
- [ ] `POST /mcp/messages?sessionId=<id>` accepts MCP client messages.
- [ ] An unknown `sessionId` on POST returns 404.

## Tools
- [ ] MCP client receives all 6 tools when listing: `search_songs`, `get_song`, `list_albums`, `get_album`, `get_artist`, `list_personnel`.
- [ ] `search_songs({ query: "..." })` returns matching song summaries.
- [ ] `get_song({ id: "..." })` returns full song with albums and personnel arrays.
- [ ] `list_albums({})` returns album summaries.
- [ ] `get_album({ id: "..." })` returns album with ordered tracklist.
- [ ] `get_artist({})` returns the canonical artist with aliases.
- [ ] `list_personnel({ song_id: "..." })` returns credits for that song.
- [ ] Tools return an MCP error (not a 500) when given an invalid UUID or non-existent ID.
- [ ] All tool results are valid JSON in a `text` content block.

## Integration
- [ ] All existing API routes (`/api/v1/*`, `/admin/*`) continue to work with the MCP router mounted.
- [ ] UI still loads (`/`) when MCP is mounted.

## Documentation
- [ ] `docs/ARCHITECTURE.md` updated to reflect confirmed transport and mount path.
- [ ] `planning/STATE.md` updated.
