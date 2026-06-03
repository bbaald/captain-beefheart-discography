import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { api } from '../api/client';
import type { AlbumDetail } from '../api/types';
import SongRow from '../components/SongRow';

export default function AlbumPage() {
  const { id } = useParams<{ id: string }>();
  const [album, setAlbum] = useState<AlbumDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    api.getAlbum(id)
      .then(setAlbum)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <Spinner />;
  if (error)   return <ErrorMsg message={error} />;
  if (!album)  return null;

  const totalSeconds = album.songs.reduce((n, s) => n + (s.running_time_seconds ?? 0), 0);
  const totalTime = totalSeconds > 0 ? formatTime(totalSeconds) : null;

  return (
    <div>
      <Link to="/" className="text-sm text-gray-500 hover:text-gray-300 mb-6 inline-block">← Discography</Link>

      <div className="flex gap-6 mb-8">
        <div className="w-40 h-40 shrink-0 bg-gray-800 rounded-lg overflow-hidden">
          {album.cover_art_url
            ? <img src={album.cover_art_url} alt={album.title} className="w-full h-full object-cover" />
            : <div className="w-full h-full flex items-center justify-center text-gray-600">
                <svg xmlns="http://www.w3.org/2000/svg" className="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
                </svg>
              </div>
          }
        </div>
        <div className="flex flex-col justify-end pb-1">
          {album.album_type && (
            <p className="text-xs text-gray-500 uppercase tracking-widest mb-1">{album.album_type}</p>
          )}
          <h1 className="text-3xl font-bold text-white">{album.title}</h1>
          {album.credited_as && <p className="text-gray-400 mt-1">{album.credited_as}</p>}
          <div className="flex items-center gap-3 mt-2 text-sm text-gray-500">
            {album.release_year && <span>{album.release_year}</span>}
            {album.songs.length > 0 && <span>{album.songs.length} track{album.songs.length !== 1 ? 's' : ''}</span>}
            {totalTime && <span>{totalTime}</span>}
            {album.record_label && <span>{album.record_label}</span>}
          </div>
        </div>
      </div>

      {album.songs.length > 0 ? (
        <div className="bg-gray-900 rounded-lg p-2">
          {album.songs.map(song => <SongRow key={song.id} song={song} />)}
        </div>
      ) : (
        <p className="text-gray-500">No tracks linked yet.</p>
      )}
    </div>
  );
}

function formatTime(seconds: number): string {
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  return `${m}:${String(s).padStart(2, '0')}`;
}

function Spinner() {
  return <div className="flex justify-center py-20"><div className="w-8 h-8 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}
function ErrorMsg({ message }: { message: string }) {
  return <p className="text-red-400 py-8">Failed to load: {message}</p>;
}
