import { Link } from 'react-router-dom';
import type { Album } from '../api/types';

interface Props { album: Album; }

export default function AlbumCard({ album }: Props) {
  const label = album.credited_as ?? '';
  const year  = album.release_year ?? '—';
  const type  = album.album_type ?? '';

  return (
    <Link to={`/albums/${album.id}`} className="group block bg-gray-900 rounded-lg overflow-hidden hover:bg-gray-800 transition-colors">
      <div className="aspect-square bg-gray-800 overflow-hidden">
        {album.cover_art_url
          ? <img src={album.cover_art_url} alt={album.title} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
          : <div className="w-full h-full flex items-center justify-center text-gray-600">
              <svg xmlns="http://www.w3.org/2000/svg" className="w-12 h-12" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={1} d="M9 19V6l12-3v13M9 19c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zm12-3c0 1.105-1.343 2-3 2s-3-.895-3-2 1.343-2 3-2 3 .895 3 2zM9 10l12-3" />
              </svg>
            </div>
        }
      </div>
      <div className="p-3">
        <p className="font-medium text-white truncate">{album.title}</p>
        {label && <p className="text-xs text-gray-400 truncate mt-0.5">{label}</p>}
        <p className="text-xs text-gray-500 mt-1">{year}{type ? ` · ${type}` : ''}</p>
      </div>
    </Link>
  );
}
