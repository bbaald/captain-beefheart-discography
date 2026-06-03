# Sprint 009 Blueprint — Admin UI

## Architecture

New routes inside the existing `src/ui` React app. No new build tooling.

```
src/ui/src/
  admin/
    AdminLayout.tsx          ← wrapper with nav + logout button
    AdminLogin.tsx           ← API key entry form
    AdminDashboard.tsx       ← counts summary
    albums/
      AdminAlbumList.tsx
      AdminAlbumForm.tsx     ← create + edit (same form, different mode)
    songs/
      AdminSongList.tsx
      AdminSongForm.tsx
    personnel/
      AdminPersonnelList.tsx
      AdminPersonnelForm.tsx
    relationships/
      AlbumTrackEditor.tsx   ← add/remove/reorder songs on an album
      SongPersonnelEditor.tsx ← add/remove personnel on a song
  lib/
    adminAuth.ts             ← getApiKey(), setApiKey(), clearApiKey()
    adminApi.ts              ← typed fetch wrapper that injects Bearer header
  App.tsx                    ← add /admin/* routes (update existing)
```

---

## Auth flow

- `adminAuth.ts` wraps `sessionStorage`:
  - `getApiKey(): string | null`
  - `setApiKey(key: string): void`
  - `clearApiKey(): void`
- `RequireAdminAuth` component: reads key; if null → `<Navigate to="/admin/login" />`
- Login page: POST `GET /health` or any endpoint to validate key
  (actually: attempt `GET /admin/api-keys` with the key; 200 = valid, 401 = invalid)

```
/admin/login         → AdminLogin (public)
/admin               → RequireAdminAuth → AdminDashboard
/admin/albums        → RequireAdminAuth → AdminAlbumList
/admin/albums/new    → RequireAdminAuth → AdminAlbumForm (create)
/admin/albums/:id    → RequireAdminAuth → AdminAlbumForm (edit)
/admin/songs         → RequireAdminAuth → AdminSongList
/admin/songs/new     → RequireAdminAuth → AdminSongForm (create)
/admin/songs/:id     → RequireAdminAuth → AdminSongForm (edit)
/admin/personnel     → RequireAdminAuth → AdminPersonnelList
/admin/personnel/new → RequireAdminAuth → AdminPersonnelForm (create)
/admin/personnel/:id → RequireAdminAuth → AdminPersonnelForm (edit)
```

---

## `adminApi.ts`

Thin wrapper around `fetch` that:
1. Reads key from `adminAuth.getApiKey()`
2. Sets `Authorization: Bearer <key>` header
3. On 401 → clears key and redirects to `/admin/login`

```ts
export async function adminFetch(path: string, init?: RequestInit) { ... }
```

---

## Form conventions

- All forms: Tailwind dark theme, consistent with existing UI
- Controlled inputs; no form library required (forms are simple)
- Submit → `adminFetch(...)` → success toast (simple state, no library)
  → redirect to list
- Edit mode: pre-populate form from `GET /albums/:id` etc.
- Delete button (with confirmation) on edit forms

---

## AdminLayout

- Sidebar or top nav with links: Dashboard · Albums · Songs · Personnel
- Logout button → `clearApiKey()` + `navigate('/admin/login')`
- "Admin" badge to distinguish from public UI

---

## Relationship editors

- `AlbumTrackEditor` — embedded on album edit page:
  - Shows current tracklist with sequence numbers
  - Add song: search box → pick → assign sequence number → POST song_albums
  - Remove: DELETE song_albums
- `SongPersonnelEditor` — embedded on song edit page:
  - Shows current personnel with roles
  - Add: pick personnel from list + enter role → POST song_personnel
  - Remove: DELETE song_personnel

---

## API endpoints used (all existing)

| Action | Endpoint |
|---|---|
| Validate key | GET /admin/api-keys |
| List albums | GET /albums |
| Get album | GET /albums/:id |
| Create album | POST /albums |
| Update album | PATCH /albums/:id |
| Delete album | DELETE /albums/:id |
| List songs | GET /songs |
| Get song | GET /songs/:id |
| Create song | POST /songs |
| Update song | PATCH /songs/:id |
| Delete song | DELETE /songs/:id |
| List personnel | GET /personnel |
| Get personnel | GET /personnel/:id |
| Create personnel | POST /personnel |
| Update personnel | PATCH /personnel/:id |
| Delete personnel | DELETE /personnel/:id |
| Add song to album | POST /song-albums |
| Remove song from album | DELETE /song-albums/:song_id/:album_id |
| Add personnel to song | POST /song-personnel |
| Remove personnel from song | DELETE /song-personnel/:song_id/:personnel_id |
