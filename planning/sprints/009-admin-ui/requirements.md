# Sprint 009 Requirements — Admin UI

## Goal

Add a protected `/admin` section to the React UI for creating and editing
albums, songs, and personnel. The admin section is completely separate from
the public-facing UI and requires an API key to access.

## In scope

- Login page at `/admin/login` — accepts an API key, stores it in
  `sessionStorage`, redirects to admin dashboard on success
- Protected route wrapper — redirects to `/admin/login` if no key in storage
- Admin dashboard at `/admin` — summary counts (albums, songs, personnel)
- Album management: list, create, edit (title, type, year, cover art URL,
  credited_as)
- Song management: list, create, edit (title, recording type, media type,
  year, recording URL, credited_as)
- Personnel management: list, create, edit (name, sort name)
- Relationship management: add/remove songs from albums (with sequence
  number), add/remove personnel from songs (with role)
- All write operations go through existing authenticated API endpoints
  (`Authorization: Bearer <key>` header on every request)
- Logout clears sessionStorage and redirects to `/admin/login`

## Out of scope

- User account system (API key is the credential)
- Role-based permissions (any valid key has full access)
- Audit log / change history
- Bulk import / CSV upload
- Image upload (cover art is a URL field only)

## Constraints

- Admin section lives inside the existing `src/ui` React app (new routes,
  not a separate app)
- API key is stored in `sessionStorage` only — cleared on tab close
- No new API endpoints needed; all required write endpoints exist from Sprint 002/003
- Public UI routes (`/`, `/albums`, `/songs`, `/search`) remain fully public
- Admin routes must not be reachable without a valid key (client-side guard +
  API enforces auth on writes)
- Tailwind dark theme consistent with existing UI

## Acceptance criteria

- Navigating to any `/admin/*` route without a stored key redirects to
  `/admin/login`
- Logging in with a valid key reaches the dashboard; invalid key shows an
  error message
- CRUD operations for albums, songs, and personnel work end-to-end
- Logout clears the key and redirects to login
- Public routes are unaffected
