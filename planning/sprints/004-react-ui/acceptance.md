# Sprint 004 Acceptance Criteria

This sprint is complete when:

## Setup
- [ ] `npm run ui:install && npm run ui:dev` starts the Vite dev server.
- [ ] `npm run ui:build` produces a `src/ui/dist/` directory.
- [ ] Tailwind utility classes render correctly.

## API client
- [ ] `client.ts` has typed functions for getAlbums, getAlbum, getSong, getSongs, search, getArtists.
- [ ] All functions use `/api/v1` as the base path.

## Pages
- [ ] **Home** (`/`) renders an album grid; each card shows title, year, and album_type.
- [ ] **Album detail** (`/albums/:id`) renders album metadata and an ordered tracklist; each track links to its song.
- [ ] **Song detail** (`/songs/:id`) renders song metadata, personnel grouped by role, and albums the song appears on.
- [ ] **Search** (`/search?q=`) renders matching songs and albums in separate sections; empty state handled.
- [ ] **Artist** (`/artist`) renders the canonical artist name and aliases list.

## UX
- [ ] All pages show a loading state while fetching.
- [ ] All pages show an error message on fetch failure.
- [ ] Navigation links between pages work (Home → Album → Song, search results link to detail pages).
- [ ] Cover art displays when a URL is present; placeholder shown when absent.

## Production integration
- [ ] `NODE_ENV=production npm start` serves the built UI from Express.
- [ ] API routes (`/api/v1/*`, `/admin/*`) still function correctly when serving the UI.
- [ ] Deep-linking to `/albums/:id` works (Express catch-all serves `index.html`).

## Documentation
- [ ] `planning/STATE.md` updated.
