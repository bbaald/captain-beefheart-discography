# Sprint 008 Acceptance Criteria — MCP Contract Tests

## Test suite

- [ ] `tests/mcp.test.ts` exists
- [ ] `npm test` exits 0 with all tests passing (including pre-existing tests)

## Coverage — each tool has:

- [ ] `search_songs` — happy path + empty result + filter
- [ ] `get_song` — happy path with albums/personnel + not-found
- [ ] `list_albums` — happy path + LP filter + Live filter
- [ ] `get_album` — happy path with ordered tracklist + not-found
- [ ] `list_personnel` — happy path with count assertion
- [ ] `get_personnel` — happy path with credits + not-found

## Response shape

- [ ] Every tool response has `content` array
- [ ] `content[0].type === 'text'`
- [ ] `content[0].text` is valid JSON (JSON.parse does not throw)
- [ ] Not-found responses have `isError: true`

## Test quality

- [ ] No hardcoded UUIDs — IDs fetched from DB in `beforeAll`
- [ ] `afterAll` closes DB pool
- [ ] Tests are independent (no shared mutable state between test cases)
