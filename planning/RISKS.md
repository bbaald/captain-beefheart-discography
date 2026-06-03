# Risks

| Risk | Likelihood | Impact | Mitigation | Status |
|---|---|---|---|---|
| MCP framework not selected | High | Medium | Decide on MCP transport (stdio, HTTP/SSE) and SDK before Sprint 003. | Open |
| Data model too rigid for edge cases (e.g., split releases, collaborations) | Medium | High | Design for flexibility: nullable fields, join tables, no hardcoded artist assumption. | Open |
| No admin auth scoped yet | Medium | High | Decide whether write endpoints require auth before API sprint. | Open |
| Source data format unknown (spreadsheet? streaming API? manual?) | High | Medium | Clarify data ingestion path in Sprint 001. | Open |
| Running time storage format (seconds int vs. HH:MM:SS string) | Low | Low | Decide in data model sprint; store as integer seconds. | Open |
| Cover art storage (binary in DB vs. external CDN URL) | Medium | Medium | Store URL only; do not store binary in PostgreSQL. | Open |
| Lyrics copyright considerations | Medium | High | Treat lyrics as optional; do not auto-populate from copyrighted sources. | Open |
