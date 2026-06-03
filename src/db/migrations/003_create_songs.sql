CREATE TABLE songs (
  id                    UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  title                 TEXT        NOT NULL,
  artist_id             UUID        NOT NULL REFERENCES artists(id),
  credited_as           TEXT,
  media_type            TEXT        NOT NULL CHECK (media_type IN ('audio', 'video')),
  recording_type        TEXT        CHECK (recording_type IN ('studio', 'live')),
  running_time_seconds  INTEGER,
  release_date          DATE,
  release_year          SMALLINT,
  recording_date        DATE,
  recording_year        SMALLINT,
  lyrics                TEXT,
  cover_art_url         TEXT,
  recording_url         TEXT,
  record_label          TEXT,
  catalog_number        TEXT,
  liner_notes           TEXT,
  source_list           TEXT[]      NOT NULL DEFAULT '{}',
  created_at            TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at            TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_songs_artist_id    ON songs(artist_id);
CREATE INDEX idx_songs_release_year ON songs(release_year);
CREATE INDEX idx_songs_media_type   ON songs(media_type);
