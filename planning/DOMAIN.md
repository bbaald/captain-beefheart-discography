# Domain Context

---

## Client

TBD

---

## Business Goal

Provide a complete, queryable record of an artist's or label's recorded output — songs, albums, personnel, and metadata — accessible via a web UI, REST API, and MCP server.

---

## Users / Roles

- **End users:** Fans, researchers, or label staff browsing and searching the discography via the web UI.
- **API consumers:** Third-party apps or internal tools querying songs and albums programmatically.
- **MCP consumers:** AI agents or tools querying the discography via the MCP interface.
- **Admins / editors:** Users who create and update song and album records. *(Admin auth scope TBD.)*

---

## Core Concepts

| Term | Meaning |
|---|---|
| Song | A single recorded work. Can be audio or video, live or studio. |
| Album | A collection of songs released together. May be an LP, EP, or compilation. |
| Single | A song released independently, not as part of an album. |
| Artist | The primary performing entity whose discography is being tracked. |
| Personnel | All humans credited on a recording: musicians, songwriters, producers, engineers. |
| Catalog number | The label's internal identifier for a release. |
| Source list | References used to populate or verify a song or album record. |

---

## Current Workflow

TBD — depends on client. Likely: manual data entry from liner notes, streaming metadata, or existing spreadsheets.

---

## Target Workflow

- Records are created and edited via admin UI or direct API.
- End users search and browse via the public web UI.
- AI agents query via MCP.

---

## Business Rules

- A song must have: title, artist, media type (audio/video), release date or year, running time, and at least one source reference.
- A song may appear on zero or more albums.
- When a song appears on an album, it has a sequence number on that album.
- Personnel roles include: musician, songwriter, producer, engineer. A person may hold multiple roles on the same song.
- Cover art, lyrics, liner notes, and recording date are optional but desirable.
- The system is "generic" — it should support any artist, not a single hardcoded artist.
