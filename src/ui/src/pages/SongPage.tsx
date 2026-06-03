import { useEffect, useState } from 'react';
import { useParams, Link } from 'react-router-dom';
import { api } from '../api/client';
import type { SongDetail, Personnel } from '../api/types';

const ROLE_ORDER = ['songwriter', 'producer', 'musician', 'engineer'] as const;
type Role = typeof ROLE_ORDER[number];

function groupPersonnel(personnel: Personnel[]): Record<string, Personnel[]> {
  const groups: Record<string, Personnel[]> = {};
  for (const p of personnel) {
    (groups[p.role] ??= []).push(p);
  }
  return groups;
}

function formatTime(s: number | null) {
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
  const roleOrder: Role[] = [...ROLE_ORDER, ...(Object.keys(groups).filter(r => !ROLE_ORDER.includes(r as Role)) as Role[])];

  return (
    <div className="max-w-2xl">
      <Link to={song.albums[0] ? `/albums/${song.albums[0].id}` : '/'} className="text-sm text-gray-500 hover:text-gray-300 mb-6 inline-block">
        ← {song.albums[0]?.title ?? 'Discography'}
      </Link>

      <h1 className="text-3xl font-bold text-white mb-1">{song.title}</h1>
      {song.credited_as && <p className="text-gray-400 mb-4">{song.credited_as}</p>}

      {/* Metadata */}
      <dl className="grid grid-cols-2 gap-x-6 gap-y-2 text-sm mb-8">
        <Meta label="Year"     value={song.release_year} />
        <Meta label="Type"     value={song.media_type === 'video' ? 'Video' : 'Audio'} />
        <Meta label="Format"   value={song.recording_type} />
        <Meta label="Duration" value={formatTime(song.running_time_seconds)} />
        <Meta label="Label"    value={song.record_label} />
        <Meta label="Catalog"  value={song.catalog_number} />
      </dl>

      {/* Listen link */}
      {song.recording_url && (
        <a href={song.recording_url} target="_blank" rel="noopener noreferrer"
           className="inline-flex items-center gap-2 text-sm text-indigo-400 hover:text-indigo-300 mb-8">
          ▶ Listen
        </a>
      )}

      {/* Personnel */}
      {song.personnel.length > 0 && (
        <section className="mb-8">
          <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Credits</h2>
          <div className="space-y-3">
            {roleOrder.filter(r => groups[r]).map(role => (
              <div key={role}>
                <p className="text-xs text-gray-500 capitalize mb-1">{role}</p>
                <ul className="space-y-0.5">
                  {groups[role].map(p => (
                    <li key={p.id + role} className="text-sm text-gray-200">
                      {p.name}{p.instrument ? <span className="text-gray-500"> — {p.instrument}</span> : null}
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
        <section className="mb-8">
          <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Lyrics</h2>
          <pre className="text-sm text-gray-300 whitespace-pre-wrap font-sans leading-relaxed">
            {song.lyrics}
          </pre>
        </section>
      )}

      {/* Albums */}
      {song.albums.length > 0 && (
        <section>
          <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Appears On</h2>
          <ul className="space-y-1">
            {song.albums.map(a => (
              <li key={a.id} className="text-sm">
                <Link to={`/albums/${a.id}`} className="text-indigo-400 hover:text-indigo-300">
                  {a.title}
                </Link>
                <span className="text-gray-500"> — track {a.sequence_number}{a.release_year ? `, ${a.release_year}` : ''}</span>
              </li>
            ))}
          </ul>
        </section>
      )}
    </div>
  );
}

function Meta({ label, value }: { label: string; value: string | number | null | undefined }) {
  if (value == null || value === '') return null;
  return (
    <>
      <dt className="text-gray-500">{label}</dt>
      <dd className="text-gray-200 capitalize">{String(value)}</dd>
    </>
  );
}
function Spinner() {
  return <div className="flex justify-center py-20"><div className="w-8 h-8 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}
function ErrorMsg({ message }: { message: string }) {
  return <p className="text-red-400 py-8">Failed to load: {message}</p>;
}
