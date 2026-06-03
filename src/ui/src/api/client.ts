import type { Artist, Album, AlbumDetail, Song, SongDetail, SearchResults } from './types';

const BASE = '/api/v1';

async function get<T>(path: string): Promise<T> {
  const res = await fetch(`${BASE}${path}`);
  if (!res.ok) throw new Error(`API error ${res.status}: ${path}`);
  return res.json() as Promise<T>;
}

function qs(params: Record<string, string | number | undefined>): string {
  const entries = Object.entries(params).filter(([, v]) => v !== undefined && v !== '');
  if (entries.length === 0) return '';
  return '?' + entries.map(([k, v]) => `${k}=${encodeURIComponent(String(v))}`).join('&');
}

export const api = {
  getArtists: () =>
    get<Artist[]>('/artists'),

  getAlbums: (params?: { album_type?: string; year?: number; sort?: string }) =>
    get<Album[]>(`/albums${qs(params ?? {})}`),

  getAlbum: (id: string) =>
    get<AlbumDetail>(`/albums/${id}`),

  getSongs: (params?: { q?: string; media_type?: string; recording_type?: string; year?: number; album_id?: string }) =>
    get<Song[]>(`/songs${qs(params ?? {})}`),

  getSong: (id: string) =>
    get<SongDetail>(`/songs/${id}`),

  search: (q: string, type?: 'song' | 'album') =>
    get<SearchResults>(`/search${qs({ q, type })}`),
};
