# Open Questions

| Question | Owner | Needed By | Status | Answer / Notes |
|---|---|---|---|---|
| Who is the client / primary stakeholder? | Architect | Sprint 002 | **Answered** | Client is the project owner (personal project). See DECISIONS.md. |
| Is this scoped to a single artist or multi-artist? | Client | Sprint 001 | **Answered** | Single artist performing under various names. One canonical artist entity with aliases. See DECISIONS.md. |
| What is the MCP transport? (stdio, HTTP/SSE, other) | Architect | Sprint 003 | **Answered** | HTTP/SSE. DB and API are remote; stdio is not viable. MCP server runs on the same host as the API. See DECISIONS.md. |
| Does the API require authentication for write operations? | Client/Architect | Sprint 002 | **Answered** | Multiple API keys. One key per consumer (scraper, admin UI, MCP server). Keys hashed in DB, shown once at creation. See DECISIONS.md. |
| What is the primary data source for initial population? (manual, spreadsheet, streaming API) | Client | Sprint 001 | **Answered** | Scraping. Ingestion happens after coding, except data needed for code testing. See DECISIONS.md. |
| Should "Artist" be a first-class entity with its own table, or a string field on Song? | Architect | Sprint 002 | **Answered** | First-class table. Required to model aliases (various names). See DECISIONS.md. |
| How should collaborations be modeled? (e.g., "Artist A feat. Artist B") | Architect | Sprint 002 | Open | Guest credits can be captured via `song_personnel` with role='musician'. True co-billed releases (split albums) are out of scope for Sprint 001. Revisit in Sprint 002. |
| Should the UI support public (read-only) and admin (read-write) views? | Client | Sprint 002 | Open | Escalated. Confirm before Sprint 002 UI scoping. |
| Where is cover art stored? (DB blob vs. CDN URL) | Architect | Sprint 002 | **Answered** | URL only. No binary storage in PostgreSQL. See DECISIONS.md. |
| What does "URL of recording of song" mean in practice? (YouTube, Spotify, internal storage?) | Client | Sprint 001 | **Answered** | Apple Music or YouTube URLs. See DECISIONS.md. |
