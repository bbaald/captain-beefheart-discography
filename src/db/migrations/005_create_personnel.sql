CREATE TABLE personnel (
  id         UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  name       TEXT        NOT NULL,
  sort_name  TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE song_personnel (
  song_id       UUID NOT NULL REFERENCES songs(id)      ON DELETE CASCADE,
  personnel_id  UUID NOT NULL REFERENCES personnel(id)  ON DELETE CASCADE,
  role          TEXT NOT NULL CHECK (role IN ('musician', 'songwriter', 'producer', 'engineer')),
  instrument    TEXT,
  PRIMARY KEY (song_id, personnel_id, role)
);
