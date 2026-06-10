import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { api } from '../api/client';
import type { SongDetail, Personnel } from '../api/types';

const ROLE_ORDER = ['songwriter', 'producer', 'musician', 'engineer'] as const;
type Role = typeof ROLE_ORDER[number];

function groupPersonnel(personnel: Personnel[]): Record<string, Personnel[]> {
  const groups: Record<string, Personnel[]> = {};
  for (const p of personnel) { (groups[p.role] ??= []).push(p); }
  return groups;
}

function fmtTime(s: number | null) {
  if (s == null) return null;
  const m = Math.floor(s / 60), sec = s % 60;
  return `${m}:${String(sec).padStart(2, '0')}`;
}

export default function SongPage() {
  const { id } = useParams<{ id: string }>();
  const [song, setSong] = useState<SongDetail | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    if (!id) return;
    api.getSong(id)
      .then(setSong)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [id]);

  if (loading) return <Spinner />;
  if (error)   return <ErrorMsg message={error} />;
  if (!song)   return null;

  const groups = groupPersonnel(song.personnel);
  const roleOrder = [
    ...ROLE_ORDER,
    ...Object.keys(groups).filter(r => !ROLE_ORDER.includes(r as Role)) as Role[],
  ];

  const metaRows: [string, string | number | null | undefined][] = [
    ['Year',     song.release_year],
    ['Type',     song.media_type === 'video' ? 'Video' : 'Audio'],
    ['Format',   song.recording_type],
    ['Duration', fmtTime(song.running_time_seconds)],
    ['Label',    song.record_label],
    ['Catalog',  song.catalog_number],
  ];

  return (
    <div className="max-w-[620px]">
      <Link
        to={song.albums[0] ? `/albums/${song.albums[0].id}` : '/'}
        className="inline-block text-[0.7rem] uppercase tracking-[0.07em] text-ink-muted hover:text-ember transition-colors mb-6"
      >
        ← {song.albums[0]?.title ?? 'Discography'}
      </Link>

      {/* Title with per-line hug background */}
      <div className="mb-5">
        <h1 className="text-hug text-[2.4rem] font-bold">{song.title}</h1>
      </div>
      {song.credited_as && (
        <p className="text-[0.9rem] text-ink-brown mb-5">{song.credited_as}</p>
      )}

      {/* Metadata table */}
      <table className="meta-table mb-7">
        <tbody>
          {metaRows
            .filter(([, v]) => v != null && v !== '')
            .map(([label, value]) => (
              <tr key={label}>
                <td>{label}</td>
                <td>{String(value)}</td>
              </tr>
            ))}
        </tbody>
      </table>

      {/* Listen */}
      {song.recording_url && (
        <a
          href={song.recording_url}
          target="_blank"
          rel="noopener noreferrer"
          className="inline-flex items-center gap-1.5 text-[0.72rem] font-medium uppercase tracking-[0.08em] text-ember border border-ember px-3.5 py-[5px] hover:bg-ember hover:text-canvas transition-colors mb-7"
        >
          ▶ Listen
        </a>
      )}

      {/* Credits */}
      {song.personnel.length > 0 && (
        <section className="mb-7">
          <h2 className="text-[0.62rem] uppercase tracking-[0.1em] text-ink-muted font-medium mb-3">
            Credits
          </h2>
          <div className="space-y-3">
            {roleOrder.filter(r => groups[r]).map(role => (
              <div key={role}>
                <p className="text-[0.62rem] uppercase tracking-[0.08em] text-ink-muted capitalize mb-1">
                  {role}
                </p>
                <ul className="space-y-0.5">
                  {groups[role].map(p => (
                    <li key={p.id + role} className="font-serif text-[0.88rem] text-ink">
                      {p.name}
                      {p.instrument && (
                        <span className="font-sans text-ink-muted"> — {p.instrument}</span>
                      )}
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </section>
      )}

      {/* Lyrics */}
      {song.lyrics && (
        <section className="mb-7">
          <h2 className="text-[0.62rem] uppercase tracking-[0.1em] text-ink-muted font-medium mb-3">
            Lyrics
          </h2>
          <pre className="font-serif italic text-[0.95rem] text-ink-brown whitespace-pre-wrap leading-[1.9]">
            {song.lyrics}
          </pre>
        </section>
      )}

      {/* Appears on */}
      {song.albums.length > 0 && (
        <section className="mb-7">
          <h2 className="text-[0.62rem] uppercase tracking-[0.1em] text-ink-muted font-medium mb-3">
            Appears On
          </h2>
          <ul className="space-y-1">
            {song.albums.map(a => (
              <li key={a.id} className="font-serif text-[0.88rem]">
                <Link to={`/albums/${a.id}`} className="text-ember hover:underline">
                  {a.title}
                </Link>
                <span className="font-sans text-[0.75rem] text-ink-muted">
                  {' '}— track {a.sequence_number}{a.release_year ? `, ${a.release_year}` : ''}
                </span>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
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
