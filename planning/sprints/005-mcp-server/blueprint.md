# Sprint 005 Blueprint — MCP Server (HTTP/SSE)

## Objective

Mount a fully functional MCP server inside the existing Express app. Six read-only tools, HTTP/SSE transport, direct DB queries.

---

## Files to Review Before Starting

- `AGENTS.md`
- `planning/STATE.md`
- `planning/DECISIONS.md`
- `docs/ARCHITECTURE.md`
- `src/api/index.ts`
- `src/db/client.ts`
- `planning/sprints/005-mcp-server/requirements.md`

---

## Files to Create or Modify

| File | Action |
|---|---|
| `src/mcp/server.ts` | Create — MCP server factory + tool definitions + DB queries |
| `src/mcp/router.ts` | Create — Express router for `/sse` and `/messages` |
| `src/api/index.ts` | Modify — mount MCP router at `/mcp` |
| `package.json` | Modify — add `@modelcontextprotocol/sdk` dependency |

---

## Key Technical Decisions

| Choice | Decision |
|---|---|
| SDK | `@modelcontextprotocol/sdk` (official TypeScript SDK) |
| Server pattern | New `Server` instance per SSE connection (factory function) — avoids shared-state issues with concurrent clients |
| Tool input validation | Zod (already in project) passed to SDK tool schemas |
| Query source | Direct `pool.query()` — no HTTP round-trip to REST API |
| Auth | None — read-only tools, public per existing policy |

---

## Implementation Steps

### 1. Install dependency

```
npm install @modelcontextprotocol/sdk
```

### 2. MCP server factory (`src/mcp/server.ts`)

Export a `createMcpServer()` function that:
- Creates a new `Server` instance from `@modelcontextprotocol/sdk/server/index.js`
- Registers `ListToolsRequestSchema` handler returning all 6 tool definitions
- Registers `CallToolRequestSchema` handler dispatching to per-tool query functions
- Returns the configured server

Tool definitions follow the MCP spec: `{ name, description, inputSchema (JSON Schema) }`.

Each tool handler runs a parameterized `pool.query()` and returns:
```ts
{ content: [{ type: 'text', text: JSON.stringify(rows) }] }
```

**Tool query sketches:**

`search_songs`: `SELECT id, title, credited_as, media_type, recording_type, running_time_seconds, release_year FROM songs WHERE title ILIKE $1 [AND media_type=$n ...] ORDER BY release_year DESC NULLS LAST, title LIMIT 50`

`get_song`: Three parallel queries — song record, albums via song_albums JOIN, personnel via song_personnel JOIN. Merge into one object.

`list_albums`: `SELECT id, title, credited_as, album_type, release_year, cover_art_url FROM albums [WHERE ...] ORDER BY release_year DESC NULLS LAST, title LIMIT 50`

`get_album`: Two parallel queries — album record + tracklist via song_albums JOIN songs ORDER BY sequence_number.

`get_artist`: `SELECT * FROM artists ORDER BY created_at LIMIT 1`

`list_personnel`: `SELECT p.id, p.name, p.sort_name, sp.role, sp.instrument FROM song_personnel sp JOIN personnel p ON p.id = sp.personnel_id WHERE sp.song_id = $1 ORDER BY sp.role, p.name`

### 3. Express router (`src/mcp/router.ts`)

```ts
import { Router } from 'express';
import { SSEServerTransport } from '@modelcontextprotocol/sdk/server/sse.js';
import { createMcpServer } from './server';

const router = Router();
const transports = new Map<string, SSEServerTransport>();

router.get('/sse', async (req, res) => {
  const transport = new SSEServerTransport('/mcp/messages', res);
  transports.set(transport.sessionId, transport);
  req.on('close', () => transports.delete(transport.sessionId));
  const server = createMcpServer();
  await server.connect(transport);
});

router.post('/messages', async (req, res) => {
  const sessionId = req.query.sessionId as string;
  const transport = transports.get(sessionId);
  if (!transport) { res.status(404).send('Session not found'); return; }
  await transport.handlePostMessage(req, res);
});

export default router;
```

### 4. Mount in Express app

In `src/api/index.ts`, add after existing routes:

```ts
import mcpRouter from '../mcp/router';
app.use('/mcp', mcpRouter);
```

### 5. Tests

Manual verification only in this sprint — connect a Claude Desktop or MCP Inspector instance to `http://<host>/mcp/sse` and confirm all 6 tools are listed and return results.

No automated tests for the MCP layer in Sprint 005. A future sprint may add contract tests.

### 6. Update docs

Update `docs/ARCHITECTURE.md` to confirm MCP transport and mount path.

---

## Notes

- Do not implement write tools.
- Do not add MCP auth in this sprint — tools are read-only and public endpoints are already unauthenticated.
- If the SDK API surface has changed since this blueprint was written, adapt the import paths and class names — the pattern (factory per connection, SSEServerTransport, ListTools + CallTool handlers) is stable.
