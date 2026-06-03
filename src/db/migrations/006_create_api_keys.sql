CREATE TABLE api_keys (
  id           UUID        PRIMARY KEY DEFAULT gen_random_uuid(),
  label        TEXT        NOT NULL,
  key_hash     TEXT        NOT NULL UNIQUE,
  created_at   TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_used_at TIMESTAMPTZ,
  revoked_at   TIMESTAMPTZ
);
