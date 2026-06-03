import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { adminApi, type Song } from '../../lib/adminApi';

export default function AdminSongList() {
  const [songs, setSongs] = useState<Song[]>([]);
  const [query, setQuery]   = useState('');
  const [loading, setLoading] = useState(true);
  const [error, setError]   = useState<string | null>(null);

  useEffect(() => {
    adminApi.getSongs()
      .then(rows => setSongs(rows.sort((a, b) => a.title.localeCompare(b.title))))
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, []);

  const filtered = query
    ? songs.filter(s => s.title.toLowerCase().includes(query.toLowerCase()))
    : songs;

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-white">Songs</h1>
        <Link to="/admin/songs/new" className={primaryBtn}>+ New Song</Link>
      </div>

      <input
        value={query}
        onChange={e => setQuery(e.target.value)}
        placeholder="Filter by title…"
        className="w-full mb-4 bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500 placeholder-gray-600"
      />

      {loading && <Spinner />}
      {error   && <p className="text-red-400 text-sm">{error}</p>}

      {!loading && !error && (
        <div className="bg-gray-900 rounded-lg overflow-hidden">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-800 text-left text-xs text-gray-500 uppercase tracking-wider">
                <th className="px-4 py-3">Title</th>
                <th className="px-4 py-3">Type</th>
                <th className="px-4 py-3">Year</th>
                <th className="px-4 py-3"></th>
              </tr>
            </thead>
            <tbody>
              {filtered.map(s => (
                <tr key={s.id} className="border-b border-gray-800 last:border-0 hover:bg-gray-800 transition-colors">
                  <td className="px-4 py-3 text-gray-100">{s.title}</td>
                  <td className="px-4 py-3 text-gray-400">{s.recording_type ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-400">{s.release_year ?? '—'}</td>
                  <td className="px-4 py-3 text-right">
                    <Link to={`/admin/songs/${s.id}`} className="text-indigo-400 hover:text-indigo-300 text-xs">
                      Edit
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
          {filtered.length === 0 && (
            <p className="text-gray-500 text-sm text-center py-6">No songs match.</p>
          )}
        </div>
      )}
    </div>
  );
}

function Spinner() {
  return <div className="flex justify-center py-12"><div className="w-6 h-6 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}

const primaryBtn = 'text-sm bg-indigo-600 hover:bg-indigo-500 text-white rounded px-4 py-2 transition-colors';
