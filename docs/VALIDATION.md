# Validation Plan

## Overview

This document defines how the Discography Database proves that its data is correct and trustworthy.

---

## Validation Principles

- Every Priority 1 field must be non-null before a record is considered "complete."
- Running time should be verified against a known source (e.g., streaming platform, physical media).
- Source list entries must be non-empty strings — at minimum, a human-readable reference.
- Album sequence numbers must be unique per album (no two songs with the same track number on the same album).
- Personnel roles must be one of the defined values: musician, songwriter, producer, engineer.

---

## Validation Checklist

| Area | Validation Method | Status | Notes |
|---|---|---|---|
| Required fields (Priority 1) | DB NOT NULL constraints + API validation | Pending | Enforce at API layer with clear error messages |
| `media_type` values | CHECK constraint: 'audio', 'video' | Pending | |
| `recording_type` values | CHECK constraint: 'studio', 'live', NULL | Pending | |
| Sequence number uniqueness | UNIQUE(album_id, sequence_number) in song_albums | Pending | |
| Personnel role values | CHECK constraint on song_personnel.role | Pending | |
| Running time reasonableness | API warning if < 10s or > 3600s | Pending | Not a hard block |
| Duplicate song detection | Query by (title, artist_id, release_year) before insert | Pending | |
| Source list non-empty | API validation: array length ≥ 1 | Pending | |
| URL format | Regex or URL parse validation at API layer | Pending | |

---

## Manual Validation

Until automated tests cover data ingestion end-to-end:

- Spot-check 5–10 records per ingestion batch against the source (liner notes, streaming platform, Discogs).
- Record discrepancies in `planning/QUESTIONS.md` until resolved.
