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
  const totalTime = totalSeconds > 0 ? fmtTotal(totalSeconds) : null;

  return (
    <div>
      <Link
        to="/"
        className="inline-block text-[0.7rem] uppercase tracking-[0.07em] text-ink-muted hover:text-ember transition-colors mb-6"
      >
        ← Discography
      </Link>

      {/* Album header */}
      <div className="flex gap-6 mb-8 items-end">
        <div className="w-36 h-36 shrink-0 border border-ink overflow-hidden bg-canvas-strong">
          {album.cover_art_url ? (
            <img src={album.cover_art_url} alt={album.title} className="w-full h-full object-cover" />
          ) : (
            <div className="w-full h-full flex items-center justify-center text-ink-muted">
              <svg xmlns="http://www.w3.org/2000/svg" className="w-10 h-10" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1}
                  d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
              </svg>
            </div>
          )}
        </div>

        <div className="flex-1 pb-px">
          {album.album_type && (
            <p className="text-[0.62rem] uppercase tracking-[0.1em] text-amber font-medium mb-[5px]">
              {album.album_type}
            </p>
          )}
          <h1 className="font-serif text-[2.2rem] font-bold text-ink leading-[1.2] mb-[6px]">
            {album.title}
          </h1>
          {album.credited_as && (
            <p className="text-[0.9rem] text-ink-brown mb-2">{album.credited_as}</p>
          )}
          <div className="flex gap-3 text-[0.72rem] text-ink-muted flex-wrap">
            {album.release_year && <span>{album.release_year}</span>}
            {album.songs.length > 0 && (
              <span>{album.songs.length} track{album.songs.length !== 1 ? 's' : ''}</span>
            )}
            {totalTime && <span>{totalTime}</span>}
            {album.record_label && <span>{album.record_label}</span>}
          </div>
        </div>
      </div>

      {/* Track table */}
      {album.songs.length > 0 ? (
        <table className="table-ruled">
          <thead>
            <tr>
              <th className="text-right">#</th>
              <th>Title</th>
              <th>Type</th>
              <th className="text-right">Duration</th>
            </tr>
          </thead>
          <tbody>
            {album.songs.map(song => <SongRow key={song.id} song={song} />)}
          </tbody>
        </table>
      ) : (
        <p className="text-ink-muted">No tracks linked yet.</p>
      )}
    </div>
  );
}

function fmtTotal(seconds: number): string {
  const h = Math.floor(seconds / 3600);
  const m = Math.floor((seconds % 3600) / 60);
  const s = seconds % 60;
  if (h > 0) return `${h}:${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`;
  return `${m}:${String(s).padStart(2, '0')}`;
}

function Spinner() {
  return (
    <div className="flex justify-center py-20">
      <div className="w-8 h-8 border-2 border-canvas-strong border-t-amber animate-spin" />
    </div>
  );
}
function ErrorMsg({ message }: { message: string }) {
  return <p className="text-ember py-8">Failed to load: {message}</p>;
}
