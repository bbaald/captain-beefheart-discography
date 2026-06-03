CREATE TABLE albums (
  id            UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  artist_id     UUID        NOT NULL REFERENCES artists(id),
  credited_as   TEXT,
  title         TEXT        NOT NULL,
  album_type    TEXT        CHECK (album_type IN ('LP', 'EP', 'Single', 'Compilation', 'Live')),
  release_date  DATE,
  release_year  SMALLINT,
  record_label  TEXT,
  catalog_number TEXT,
  cover_art_url TEXT,
  liner_notes   TEXT,
  source_list   TEXT[]      NOT NULL DEFAULT '{}',
  created_at    TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at    TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_albums_artist_id    ON albums(artist_id);
CREATE INDEX idx_albums_release_year ON albums(release_year);
