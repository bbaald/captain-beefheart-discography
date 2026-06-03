export interface Artist {
  id: string;
  name: string;
  sort_name: string | null;
  aliases: string[];
  created_at: string;
  updated_at: string;
}

export interface Album {
  id: string;
  artist_id: string;
  credited_as: string | null;
  title: string;
  album_type: 'LP' | 'EP' | 'Single' | 'Compilation' | 'Live' | null;
  release_date: string | null;
  release_year: number | null;
  record_label: string | null;
  catalog_number: string | null;
  cover_art_url: string | null;
  liner_notes: string | null;
  source_list: string[];
  created_at: string;
  updated_at: string;
}

export interface Song {
  id: string;
  title: string;
  artist_id: string;
  credited_as: string | null;
  media_type: 'audio' | 'video';
  recording_type: 'studio' | 'live' | null;
  running_time_seconds: number | null;
  release_date: string | null;
  release_year: number | null;
  recording_year: number | null;
  lyrics: string | null;
  cover_art_url: string | null;
  recording_url: string | null;
  record_label: string | null;
  catalog_number: string | null;
  liner_notes: string | null;
  source_list: string[];
  created_at: string;
  updated_at: string;
}

export interface Personnel {
  id: string;
  name: string;
  sort_name: string | null;
  role: 'musician' | 'songwriter' | 'producer' | 'engineer';
  instrument: string | null;
}

export interface SongRow extends Song {
  sequence_number: number;
}

export interface AlbumRow extends Album {
  sequence_number: number;
}

export interface AlbumDetail extends Album {
  songs: SongRow[];
}

export interface SongDetail extends Song {
  albums: AlbumRow[];
  personnel: Personnel[];
}

export interface SearchResults {
  query: string;
  results: {
    songs:  { id: string; name: string; release_year: number | null }[];
    albums: { id: string; name: string; release_year: number | null }[];
  };
}
