CREATE TABLE song_albums (
  song_id         UUID     NOT NULL REFERENCES songs(id)  ON DELETE CASCADE,
  album_id        UUID     NOT NULL REFERENCES albums(id) ON DELETE CASCADE,
  sequence_number SMALLINT NOT NULL,
  PRIMARY KEY (song_id, album_id),
  UNIQUE (album_id, sequence_number)
);
