# Sprint 009 Handoff Prompt — Admin UI

You are the Builder for the Discography Database project. Read `AGENTS.md`
first, then `planning/STATE.md`, then this sprint's files in
`planning/sprints/009-admin-ui/`.

## Your task

Add a protected `/admin` section to the existing React UI in `src/ui`.

## Key files to read before writing any code

- `planning/sprints/009-admin-ui/requirements.md`
- `planning/sprints/009-admin-ui/blueprint.md`
- `planning/sprints/009-admin-ui/acceptance.md`
- `src/ui/src/App.tsx` (existing routes)
- `src/ui/src/pages/AlbumDetail.tsx` (style reference)
- `src/api/routes/albums.ts` (available endpoints + auth middleware)
- `src/api/middleware/auth.ts` (how Bearer token auth works)
- `docs/ARCHITECTURE.md`

## Deliver

1. All files under `src/ui/src/admin/` per the blueprint
2. `src/ui/src/lib/adminAuth.ts`
3. `src/ui/src/lib/adminApi.ts`
4. Updated `src/ui/src/App.tsx` with `/admin/*` routes
5. Update `planning/STATE.md`
6. Update `docs/ARCHITECTURE.md` — note the admin section

## Constraints

- `sessionStorage` only — no `localStorage` for the API key
- No new npm dependencies in `src/ui` unless absolutely necessary; prefer
  what Tailwind + React Router already provide
- Public routes must be unaffected — verify by reading `App.tsx` carefully
  before editing
- Admin section must use the same dark Tailwind theme as the public UI
