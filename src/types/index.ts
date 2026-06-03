export interface Artist {
  id: string;
  name: string;
  sort_name: string | null;
  aliases: string[];
  created_at: Date;
  updated_at: Date;
}

export interface Album {
  id: string;
  artist_id: string;
  credited_as: string | null;
  title: string;
  album_type: 'LP' | 'EP' | 'Single' | 'Compilation' | 'Live' | null;
  release_date: Date | null;
  release_year: number | null;
  record_label: string | null;
  catalog_number: string | null;
  cover_art_url: string | null;
  liner_notes: string | null;
  source_list: string[];
  created_at: Date;
  updated_at: Date;
}

export interface Song {
  id: string;
  title: string;
  artist_id: string;
  credited_as: string | null;
  media_type: 'audio' | 'video';
  recording_type: 'studio' | 'live' | null;
  running_time_seconds: number | null;
  release_date: Date | null;
  release_year: number | null;
  recording_date: Date | null;
  recording_year: number | null;
  lyrics: string | null;
  cover_art_url: string | null;
  recording_url: string | null;
  record_label: string | null;
  catalog_number: string | null;
  liner_notes: string | null;
  source_list: string[];
  created_at: Date;
  updated_at: Date;
}

export interface ApiKey {
  id: string;
  label: string;
  created_at: Date;
  last_used_at: Date | null;
  revoked_at: Date | null;
}
