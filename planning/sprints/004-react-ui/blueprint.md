# Sprint 004 Blueprint — React UI (Public Browsing)

## Objective

A working Vite + React + Tailwind public UI with five pages, served by the existing Express API in production.

---

## Files to Review Before Starting

- `AGENTS.md`
- `planning/STATE.md`
- `docs/API.md`
- `docs/ARCHITECTURE.md`
- `planning/sprints/004-react-ui/requirements.md`

---

## Project Structure

```text
src/ui/
├── index.html
├── package.json
├── vite.config.ts
├── tsconfig.json
├── tailwind.config.ts
├── postcss.config.cjs
└── src/
    ├── main.tsx
    ├── App.tsx
    ├── index.css            # Tailwind directives
    ├── api/
    │   └── client.ts        # typed fetch wrapper for all API endpoints used
    ├── components/
    │   ├── Layout.tsx        # nav bar + page wrapper
    │   ├── AlbumCard.tsx     # used on Home and Artist pages
    │   └── SongRow.tsx       # used on Album detail page
    └── pages/
        ├── HomePage.tsx
        ├── AlbumPage.tsx
        ├── SongPage.tsx
        ├── SearchPage.tsx
        └── ArtistPage.tsx
```

Express change (one addition to `src/server.ts`): serve `src/ui/dist/` as static files when `NODE_ENV=production`.

---

## Implementation Steps

### 1. Vite project setup (`src/ui/`)

**`package.json`** — separate from the root. Scripts:
- `dev`: `vite`
- `build`: `vite build`
- `preview`: `vite preview`

Dependencies: `react`, `react-dom`, `react-router-dom`
Dev dependencies: `vite`, `@vitejs/plugin-react`, `typescript`, `@types/react`, `@types/react-dom`, `tailwindcss`, `postcss`, `autoprefixer`

**`vite.config.ts`**:
```ts
server: {
  proxy: { '/api': 'http://localhost:3000' }
}
```

**`tailwind.config.ts`**: content paths covering `./src/**/*.{ts,tsx}`.

**`postcss.config.cjs`**: tailwindcss + autoprefixer plugins.

**`tsconfig.json`**: strict, jsx react-jsx, target ES2020.

### 2. API client (`src/ui/src/api/client.ts`)

Typed functions for every endpoint the UI needs:

```ts
getArtists()                              → Artist[]
getAlbums(params?)                        → Album[]
getAlbum(id)                              → Album & { songs: SongRow[] }
getSongs(params?)                         → Song[]
getSong(id)                               → Song & { albums: AlbumRow[]; personnel: PersonnelRow[] }
search(q, type?)                          → SearchResults
```

Base URL is `/api/v1` (works in both dev via proxy and production via same origin).
All functions throw on non-OK responses.

### 3. Shared types (`src/ui/src/api/types.ts`)

Mirror the relevant API response shapes. Keep them minimal — only fields the UI actually displays.

### 4. Layout component

Sticky nav bar with:
- Site name / home link on the left
- Links: Discography, Artist, Search on the right

Simple, clean — no heavy framework. Tailwind utility classes only.

### 5. Pages

**HomePage** — `useEffect` → `getAlbums({ sort: 'release_year' })` → grid of `AlbumCard` components.

**AlbumPage** — `useEffect` → `getAlbum(id)` → header (title, year, label, cover art) + ordered list of `SongRow` components.

**SongPage** — `useEffect` → `getSong(id)` → metadata table + personnel grouped by role + albums list.

**SearchPage** — controlled input synced to `?q=` URL param. `useEffect` on `q` → `search(q)` → two result sections (Songs, Albums). Debounce is optional.

**ArtistPage** — `useEffect` → `getArtists()` → display first result: name, aliases, (counts optional).

### 6. Loading and error states

Each page shows a simple loading spinner (CSS only, no library) while fetching and an error message if the request fails. No global state management needed.

### 7. Express static serving (production)

Add to `src/server.ts` after imports:

```ts
import path from 'path';
if (process.env.NODE_ENV === 'production') {
  app.use(express.static(path.join(__dirname, '../src/ui/dist')));
  app.get('*', (_req, res) => {
    res.sendFile(path.join(__dirname, '../src/ui/dist/index.html'));
  });
}
```

Mount this **after** all API routes so API routes take precedence.

### 8. Root package.json scripts (add)

```json
"ui:dev":   "cd src/ui && npm run dev",
"ui:build": "cd src/ui && npm run build",
"ui:install": "cd src/ui && npm install"
```

### 9. Tests

No automated UI tests in this sprint. Manual acceptance testing against the running API is sufficient.

---

## Notes

- Do not add a component library (shadcn, MUI, etc.) — Tailwind only.
- Do not add a global state manager (Redux, Zustand) — local state is sufficient.
- Do not implement admin/write UI.
- Keep the API client thin — no caching layer yet.
