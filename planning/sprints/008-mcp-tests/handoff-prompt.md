# Sprint 008 Handoff Prompt — MCP Contract Tests

You are the Builder for the Discography Database project. Read `AGENTS.md`
first, then `planning/STATE.md`, then this sprint's files in
`planning/sprints/008-mcp-tests/`.

## Your task

Write `tests/mcp.test.ts` — integration tests for all six MCP tools defined
in `src/mcp/server.ts`.

## Key files to read before writing any code

- `planning/sprints/008-mcp-tests/requirements.md`
- `planning/sprints/008-mcp-tests/blueprint.md`
- `planning/sprints/008-mcp-tests/acceptance.md`
- `src/mcp/server.ts` (the implementation under test)
- `tests/songs.test.ts` (pattern reference for existing tests)
- `src/db/client.ts` (pool import)

## Deliver

1. `tests/mcp.test.ts`
2. Any small exports added to `src/mcp/server.ts` needed to make handlers
   testable (e.g., exported `handlers` object) — document the change
3. Update `planning/STATE.md`

## Constraints

- `npm test` must exit 0 with all tests (old + new) passing
- No hardcoded UUIDs — resolve IDs from the DB in `beforeAll`
- No new devDependencies beyond what is already installed
- Do not modify existing test files
