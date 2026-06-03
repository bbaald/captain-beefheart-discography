import { Link } from 'react-router-dom';
import type { SongRow as SongRowType } from '../api/types';

interface Props { song: SongRowType; }

function formatTime(seconds: number | null): string {
  if (seconds == null) return '—';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${String(s).padStart(2, '0')}`;
}

export default function SongRow({ song }: Props) {
  return (
    <div className="flex items-center gap-3 px-2 py-2 rounded hover:bg-gray-800 group">
      <span className="w-6 text-right text-sm text-gray-500 shrink-0">{song.sequence_number}</span>
      <div className="flex-1 min-w-0">
        <Link to={`/songs/${song.id}`} className="text-sm text-white hover:text-indigo-400 truncate block">
          {song.title}
        </Link>
        {song.credited_as && (
          <p className="text-xs text-gray-500 truncate">{song.credited_as}</p>
        )}
      </div>
      <div className="flex items-center gap-3 shrink-0">
        {song.media_type === 'video' && (
          <span className="text-xs text-gray-600 uppercase tracking-wide">video</span>
        )}
        {song.recording_type && (
          <span className="text-xs text-gray-600">{song.recording_type}</span>
        )}
        {song.recording_url && (
          <a href={song.recording_url} target="_blank" rel="noopener noreferrer"
             className="text-xs text-gray-500 hover:text-indigo-400" title="Listen">▶</a>
        )}
        <span className="text-sm text-gray-500 w-10 text-right">{formatTime(song.running_time_seconds)}</span>
      </div>
    </div>
  );
}
