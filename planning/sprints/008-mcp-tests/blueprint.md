# Sprint 008 Blueprint — MCP Contract Tests

## Architecture

New test file added to the existing `tests/` directory. Tests call MCP tool
handler functions directly by extracting them from the `McpServer` instance
created by `createMcpServer()`.

```
tests/
  mcp.test.ts   ← new
```

---

## Test strategy

Import `createMcpServer` from `src/mcp/server.ts`. The `McpServer` instance
exposes registered tools; call their handler callbacks directly with typed
args rather than over HTTP. This avoids port binding and makes tests fast.

If the SDK does not expose handlers directly, wrap each handler in a thin
testable function exported from `server.ts`:

```ts
// src/mcp/server.ts addition
export const handlers = {
  search_songs: async (args: SearchSongsArgs) => { ... },
  get_song:     async (args: GetSongArgs)     => { ... },
  // ...
};
```

Tests import and call `handlers.search_songs(...)` directly.

---

## Test cases per tool

### `search_songs`
- Returns array of songs matching a known title (`'Electricity'`)
- Returns empty array for a nonsense query (`'xyzzy_no_match'`)
- `recording_type` filter narrows results correctly
- Response shape: `content[0].type === 'text'`, JSON-parseable, array

### `get_song`
- Returns full song object for a known song ID (include albums + personnel)
- Returns `isError: true` for a random UUID that doesn't exist
- Response shape includes `title`, `albums`, `personnel` keys

### `list_albums`
- Returns all albums (count ≥ 19)
- `album_type: 'LP'` filter returns only LPs (count ≥ 14)
- `album_type: 'Live'` filter returns only live albums (count ≥ 5)
- Response shape: array of objects with `title`, `release_year`

### `get_album`
- Returns album with `tracks` array for a known album title
- `tracks` are ordered by `sequence_number`
- Returns `isError: true` for unknown UUID

### `list_personnel`
- Returns array with count ≥ 47
- Response shape: objects with `name`, `id`

### `get_personnel`
- Returns personnel with `credits` array for a known name
- Returns `isError: true` for unknown UUID

---

## Test fixtures

Use `pool.query` in `beforeAll` to fetch a real song ID, album ID, and
personnel ID from the seeded database. Store them in variables reused across
tests. No brittle hardcoded UUIDs.

```ts
let knownSongId: string;
let knownAlbumId: string;
let knownPersonnelId: string;

beforeAll(async () => {
  const s = await pool.query("SELECT id FROM songs WHERE title = 'Electricity' LIMIT 1");
  knownSongId = s.rows[0].id;
  // ...
});

afterAll(() => pool.end());
```

---

## File layout

```
tests/mcp.test.ts
```

No new config needed — vitest already runs `tests/**/*.test.ts`.
