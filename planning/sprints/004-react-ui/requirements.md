# Sprint 004 Requirements — React UI (Public Browsing)

## Goal

Build a read-only public web UI for browsing and searching the discography.

---

## Business Objective

Give end users a clean way to explore albums, songs, and personnel without touching the API directly. Admin write operations are out of scope for this sprint.

---

## Users

End users — fans, researchers, or the owner browsing their own discography.

---

## In Scope

### Pages
- **Home** (`/`) — album grid sorted by release year, newest first. Each card shows title, credited_as, year, album_type, cover art (if present).
- **Album detail** (`/albums/:id`) — album metadata + ordered tracklist. Each track links to its song detail page.
- **Song detail** (`/songs/:id`) — full song metadata, personnel credits grouped by role, list of albums the song appears on.
- **Search** (`/search?q=`) — search box with live-routed results; songs and albums shown in separate sections.
- **Artist** (`/artist`) — canonical name, aliases list, total song/album counts.

### Infrastructure
- Vite + React + TypeScript project in `src/ui/`.
- Tailwind CSS for styling.
- React Router v6 for client-side routing.
- Typed API client (`src/ui/src/api/client.ts`) wrapping fetch.
- Vite dev proxy: `/api` → `http://localhost:3000` (no CORS config needed in dev).
- Express serves built UI static files in production (`src/ui/dist/`).

---

## Out of Scope

- Admin UI (create/edit/delete operations).
- Authentication UI.
- Pagination UI (list endpoints default to 50 results — sufficient for now).
- Lyrics display.
- MCP server.

---

## Business Rules

- All data is fetched from the existing REST API — no direct DB access from the UI.
- The UI is fully read-only; no write endpoints are called.
- If cover art URL is absent, show a neutral placeholder.
- The artist page uses the single canonical artist record (first result from `GET /api/v1/artists`).
