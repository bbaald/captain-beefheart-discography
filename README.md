# Captain Beefheart Discography

A personal discography database for Captain Beefheart — browsable web UI, REST API, and an MCP server for AI agents.

---

## What's inside

| Layer | Tech |
|---|---|
| Database | PostgreSQL |
| API | Node.js / Express / TypeScript |
| Web UI | React / Vite / Tailwind CSS |
| MCP server | `@modelcontextprotocol/sdk` (Streamable HTTP) |

---

## Quick start (using the included data export)

### 1. Prerequisites

- Node.js 20+
- PostgreSQL 14+
- A `.env` file at the project root:

```env
DATABASE_URL=postgres://user:password@localhost:5432/discography
PORT=3000
```

### 2. Install dependencies

```bash
npm install
npm run ui:install
```

### 3. Restore the database

```bash
psql $DATABASE_URL < captain-beefheart-discography.sql
```

This loads the complete schema plus all albums, songs, personnel, credits, lyrics, and artwork URLs. No migrations or seeding needed.

### 4. Generate an admin API key

```bash
npm run seed:key
```

The raw key is printed once — copy it and store it somewhere safe. Only the SHA-256 hash is kept in the database.

### 5. Start the servers

```bash
# Terminal 1 — API (port 3000)
npm run dev

# Terminal 2 — UI dev server (port 5173)
npm run ui:dev
```

Open **http://localhost:5173** to browse the site, or **http://localhost:5173/admin** to manage data.

---

## Starting from a blank database

Use this path if you're forking the project for a different artist.

```bash
# 1. Create the schema
npm run migrate

# 2. Seed artist, albums, songs, and personnel
npm run seed:data

# 3. Fetch and apply cover art (iTunes)
npm run fetch:album-artwork
npm run apply:album-artwork

# 4. Fetch and apply lyrics (lyrics.ovh)
npm run fetch:lyrics
npm run apply:lyrics

# 5. Fetch and apply Apple Music recording URLs
npm run search:apple-music
npm run apply:apple-music-urls

# 6. Generate an admin API key
npm run seed:key
```

To target a different artist, update the artist name in `scripts/fetch-lyrics.ts` and `scripts/fetch-album-artwork.ts`, and replace `data/beefheart.json` with your own source data before running `seed:data`.

---

## All scripts

| Script | What it does |
|---|---|
| `npm run migrate` | Run pending DB migrations against a blank database |
| `npm run seed:data` | Seed albums, songs, personnel from `data/beefheart.json` |
| `npm run seed:key` | Generate an admin API key |
| `npm run fetch:album-artwork` | Fetch cover art URLs from iTunes |
| `npm run apply:album-artwork` | Write artwork URLs to the DB |
| `npm run fetch:lyrics` | Fetch song lyrics from lyrics.ovh |
| `npm run apply:lyrics` | Write lyrics to the DB |
| `npm run search:apple-music` | Fetch Apple Music recording URLs for songs |
| `npm run apply:apple-music-urls` | Write recording URLs to the DB |
| `npm run test` | Run the test suite |

---

## API

Base URL: `http://localhost:3000/api/v1`

All write endpoints (`POST`, `PATCH`, `DELETE`) require:
```
Authorization: Bearer <your-api-key>
```

### Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/artists` | List artists |
| GET | `/albums` | List albums |
| GET | `/albums/:id` | Album detail (includes tracklist) |
| GET | `/songs` | List songs |
| GET | `/songs/:id` | Song detail (includes personnel, lyrics) |
| GET | `/personnel` | List personnel |
| GET | `/personnel/:id` | Person detail |
| GET | `/search?q=` | Full-text search |
| POST | `/albums` | Create album |
| PATCH | `/albums/:id` | Update album |
| DELETE | `/albums/:id` | Delete album |
| POST | `/songs` | Create song |
| PATCH | `/songs/:id` | Update song |
| DELETE | `/songs/:id` | Delete song |
| POST | `/personnel` | Create person |
| PATCH | `/personnel/:id` | Update person |
| DELETE | `/personnel/:id` | Delete person |
| POST | `/song-albums` | Add song to album |
| DELETE | `/song-albums/:song_id/:album_id` | Remove song from album |
| POST | `/song-personnel` | Add personnel credit to song |
| DELETE | `/song-personnel/:song_id/:personnel_id` | Remove credit |

---

## MCP server

The MCP server runs at `http://localhost:3000/mcp` using the Streamable HTTP transport.

To connect it to Claude Desktop, add to `~/Library/Application Support/Claude/claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "discography": {
      "url": "http://localhost:3000/mcp"
    }
  }
}
```

### Available tools

| Tool | Description |
|---|---|
| `search_songs` | Search by title or lyrics |
| `get_song` | Full song record — personnel, albums, lyrics |
| `list_albums` | List albums, filter by type/year |
| `get_album` | Album detail with tracklist |
| `get_artist` | Artist record |
| `list_personnel` | All musicians |
