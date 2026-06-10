import { Link } from 'react-router-dom';
import type { Album } from '../api/types';

interface Props { album: Album; }

export default function AlbumCard({ album }: Props) {
  const year = album.release_year ?? '—';
  const type = album.album_type ?? '';

  return (
    <Link
      to={`/albums/${album.id}`}
      className="group block bg-canvas-muted hover:bg-canvas-strong transition-colors"
    >
      <div className="aspect-square bg-canvas-strong overflow-hidden">
        {album.cover_art_url ? (
          <img
            src={album.cover_art_url}
            alt={album.title}
            className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300"
          />
        ) : (
          <div className="w-full h-full flex items-center justify-center text-ink-muted">
            <svg
              xmlns="http://www.w3.org/2000/svg"
              className="w-10 h-10"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                strokeLinecap="round"
                strokeLinejoin="round"
                strokeWidth={1}
                d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3"
              />
            </svg>
          </div>
        )}
      </div>
      <div className="p-[10px] border-t border-ink">
        {type && (
          <p className="text-[0.62rem] uppercase tracking-[0.08em] text-amber mb-[2px]">
            {type}
          </p>
        )}
        <p className="font-serif font-semibold text-[0.82rem] text-ink leading-snug mb-[3px]">
          {album.title}
        </p>
        <p className="text-[0.68rem] text-ink-muted">{year}</p>
      </div>
    </Link>
  );
}
