import { Link } from 'react-router-dom';
import type { SongRow as SongRowType } from '../api/types';

interface Props { song: SongRowType; }

function fmt(seconds: number | null): string {
  if (seconds == null) return '—';
  const m = Math.floor(seconds / 60);
  const s = seconds % 60;
  return `${m}:${String(s).padStart(2, '0')}`;
}

/**
 * Renders a <tr> — must be placed inside a <table class="table-ruled"><tbody>.
 */
export default function SongRow({ song }: Props) {
  return (
    <tr>
      <td className="text-right text-[0.75rem] text-ink-muted w-9 tabular-nums select-none">
        {song.sequence_number}
      </td>

      <td>
        <Link
          to={`/songs/${song.id}`}
          className="text-[0.875rem] text-ink hover:text-ember block"
        >
          {song.title}
        </Link>
        {song.credited_as && (
          <span className="text-[0.72rem] text-ink-muted block mt-[1px]">
            {song.credited_as}
          </span>
        )}
      </td>

      <td className="text-[0.68rem] uppercase tracking-[0.05em] text-ink-muted w-14">
        {song.recording_type ?? '—'}
      </td>

      <td className="text-right text-[0.78rem] text-ink-muted w-12 tabular-nums">
        {song.recording_url && (
          <a
            href={song.recording_url}
            target="_blank"
            rel="noopener noreferrer"
            className="text-ember hover:text-ember-light mr-2"
            title="Listen"
          >
            ▶
          </a>
        )}
        {fmt(song.running_time_seconds)}
      </td>
    </tr>
  );
}
