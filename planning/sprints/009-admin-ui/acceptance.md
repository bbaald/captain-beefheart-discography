# Sprint 009 Acceptance Criteria — Admin UI

## Auth

- [ ] Navigating to `/admin` without a stored key redirects to `/admin/login`
- [ ] Navigating to `/admin/albums`, `/admin/songs`, `/admin/personnel` without
      a key redirects to `/admin/login`
- [ ] Submitting an invalid key on the login page shows an error message (no redirect)
- [ ] Submitting a valid key redirects to `/admin` dashboard
- [ ] Clicking logout clears the key and redirects to `/admin/login`
- [ ] Closing and reopening the tab clears the session (sessionStorage)

## Dashboard

- [ ] `/admin` shows total counts for albums, songs, and personnel

## Albums

- [ ] List page shows all albums with title and year
- [ ] Create form: fills in and submits → new album appears in list
- [ ] Edit form: pre-populated from existing album → change and save works
- [ ] Delete: confirmation prompt → album removed from list

## Songs

- [ ] List page shows all songs with title and recording type
- [ ] Create, edit, delete work end-to-end (same criteria as albums)
- [ ] Recording URL field is present on the form

## Personnel

- [ ] List page shows all personnel with name
- [ ] Create, edit, delete work end-to-end

## Relationships

- [ ] Album edit page shows current tracklist
- [ ] Can add a song to an album with a sequence number
- [ ] Can remove a song from an album
- [ ] Song edit page shows current personnel
- [ ] Can add a personnel member to a song with a role
- [ ] Can remove a personnel member from a song

## Public UI

- [ ] `/`, `/albums`, `/songs`, `/search` are unaffected and load without error
- [ ] No admin-only code or state leaks into public pages
