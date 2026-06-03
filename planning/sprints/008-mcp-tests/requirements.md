# Sprint 008 Requirements — MCP Contract Tests

## Goal

Write automated tests for all six MCP tools to verify correct responses,
error handling, and schema shape — giving confidence before Claude Desktop
or other MCP clients connect.

## In scope

- Integration tests for all six tools, running against the real test database:
  - `search_songs` — returns array, respects filters, handles empty results
  - `get_song` — returns full song with albums + personnel; 404 shape on miss
  - `list_albums` — returns array, respects `album_type` filter
  - `get_album` — returns album with tracklist; 404 shape on miss
  - `list_personnel` — returns array
  - `get_personnel` — returns personnel with credits; 404 shape on miss
- Tests call tool handler functions directly (not over HTTP) to keep tests fast
  and avoid port conflicts
- Vitest test runner (already in devDependencies)

## Out of scope

- End-to-end HTTP transport tests (StreamableHTTP session handshake)
- Claude Desktop integration testing
- Load or performance testing

## Constraints

- Tests must pass with `npm test`
- Test DB must have at least the seeded Captain Beefheart data (or a
  dedicated fixture subset)
- No new runtime dependencies; test-only helpers are fine
- Existing 003-era tests must continue to pass

## Acceptance criteria

- `npm test` runs all tests including new MCP tests and exits 0
- Each tool has at least: one happy-path test, one empty/not-found test
- Tool response shape is asserted (has `content` array, `type: 'text'`,
  parseable JSON in `text`)
- `isError: true` is asserted for not-found cases
