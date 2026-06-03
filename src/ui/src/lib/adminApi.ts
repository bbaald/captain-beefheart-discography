import { getApiKey, clearApiKey } from './adminAuth';

const BASE = '/api/v1';

export class AdminAuthError extends Error {}

async function request<T>(
  path: string,
  init: RequestInit = {},
): Promise<T> {
  const key = getApiKey();
  const res = await fetch(`${BASE}${path}`, {
    ...init,
    headers: {
      'Content-Type': 'application/json',
      ...(key ? { Authorization: `Bearer ${key}` } : {}),
      ...(init.headers ?? {}),
    },
  });

  if (res.status === 401) {
    clearApiKey();
    window.location.href = '/admin/login';
    throw new AdminAuthError('Session expired');
  }

  if (!res.ok) {
    const body = await res.json().catch(() => ({}));
    throw new Error(body?.error ?? `HTTP ${res.status}`);
  }

  if (res.status === 204) return undefined as T;
  return res.json() as Promise<T>;
}

export const adminApi = {
  // ── Key validation ────────────────────────────────────────────────────────
  validateKey: () => request<unknown>('/admin/api-keys'),

  // ── Stats ─────────────────────────────────────────────────────────────────
  getStats: async () => {
    const [albums, songs, personnel] = await Promise.all([
      request<{ id: string }[]>('/albums?limit=1'),
      request<{ id: string }[]>('/songs?limit=1'),
      request<{ id: string }[]>('/personnel?limit=1'),
    ]);
    // Use count headers or just fetch all IDs for totals
    const [aCount, sCount, pCount] = await Promise.all([
      request<{ id: string }[]>('/albums?limit=200').then(r => r.length),
      request<{ id: string }[]>('/songs?limit=300').then(r => r.length),
      request<{ id: string }[]>('/personnel?limit=200').then(r => r.length),
    ]);
    return { albums: aCount, songs: sCount, personnel: pCount };
  },

  // ── Artist ────────────────────────────────────────────────────────────────
  getArtistId: async (): Promise<string> => {
    const rows = await request<{ id: string }[]>('/artists');
    return rows[0].id;
  },

  // ── Albums ────────────────────────────────────────────────────────────────
  getAlbums: (params = '') => request<Album[]>(`/albums?limit=200${params}`),
  getAlbum:  (id: string) => request<AlbumDetail>(`/albums/${id}`),
  createAlbum: (body: AlbumWrite) => request<Album>('/albums', { method: 'POST', body: JSON.stringify(body) }),
  updateAlbum: (id: string, body: Partial<AlbumWrite>) =>
    request<Album>(`/albums/${id}`, { method: 'PATCH', body: JSON.stringify(body) }),
  deleteAlbum: (id: string) => request<void>(`/albums/${id}`, { method: 'DELETE' }),

  // ── Songs ─────────────────────────────────────────────────────────────────
  getSongs: (params = '') => request<Song[]>(`/songs?limit=300${params}`),
  getSong:  (id: string)  => request<SongDetail>(`/songs/${id}`),
  createSong: (body: SongWrite) => request<Song>('/songs', { method: 'POST', body: JSON.stringify(body) }),
  updateSong: (id: string, body: Partial<SongWrite>) =>
    request<Song>(`/songs/${id}`, { method: 'PATCH', body: JSON.stringify(body) }),
  deleteSong: (id: string) => request<void>(`/songs/${id}`, { method: 'DELETE' }),

  // ── Personnel ─────────────────────────────────────────────────────────────
  getAllPersonnel: (params = '') => request<PersonnelRow[]>(`/personnel?limit=200${params}`),
  getPersonnel:   (id: string)  => request<PersonnelRow>(`/personnel/${id}`),
  createPersonnel: (body: PersonnelWrite) =>
    request<PersonnelRow>('/personnel', { method: 'POST', body: JSON.stringify(body) }),
  updatePersonnel: (id: string, body: Partial<PersonnelWrite>) =>
    request<PersonnelRow>(`/personnel/${id}`, { method: 'PATCH', body: JSON.stringify(body) }),
  deletePersonnel: (id: string) => request<void>(`/personnel/${id}`, { method: 'DELETE' }),

  // ── Song-Albums ───────────────────────────────────────────────────────────
  addSongToAlbum: (song_id: string, album_id: string, sequence_number: number) =>
    request<unknown>('/song-albums', { method: 'POST', body: JSON.stringify({ song_id, album_id, sequence_number }) }),
  removeSongFromAlbum: (song_id: string, album_id: string) =>
    request<void>(`/song-albums/${song_id}/${album_id}`, { method: 'DELETE' }),

  // ── Song-Personnel ────────────────────────────────────────────────────────
  addPersonnelToSong: (song_id: string, personnel_id: string, role: string) =>
    request<unknown>('/song-personnel', { method: 'POST', body: JSON.stringify({ song_id, personnel_id, role }) }),
  removePersonnelFromSong: (song_id: string, personnel_id: string) =>
    request<void>(`/song-personnel/${song_id}/${personnel_id}`, { method: 'DELETE' }),
};

// ── Types ──────────────────────────────────────────────────────────────────

export interface Album {
  id: string; title: string; credited_as: string | null;
  album_type: string | null; release_year: number | null;
  cover_art_url: string | null; artist_id: string;
}
export interface AlbumDetail extends Album {
  songs: SongRow[];
}
export interface SongRow {
  id: string; title: string; sequence_number: number;
  recording_type: string | null; release_year: number | null;
}
export interface Song {
  id: string; title: string; credited_as: string | null;
  media_type: string; recording_type: string | null;
  release_year: number | null; recording_url: string | null;
  artist_id: string;
}
export interface SongDetail extends Song {
  albums: { id: string; title: string; sequence_number: number }[];
  personnel: { id: string; name: string; role: string; instrument: string | null }[];
}
export interface PersonnelRow {
  id: string; name: string; sort_name: string | null;
}
export interface AlbumWrite {
  artist_id: string; title: string;
  credited_as?: string; album_type?: string;
  release_year?: number; cover_art_url?: string;
}
export interface SongWrite {
  artist_id: string; title: string;
  media_type: string; running_time_seconds: number;
  release_year: number; source_list: string[];
  credited_as?: string; recording_type?: string;
  recording_url?: string;
}
export interface PersonnelWrite {
  name: string; sort_name?: string;
}
