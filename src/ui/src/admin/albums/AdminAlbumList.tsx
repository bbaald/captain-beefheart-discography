import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { adminApi, type Album } from '../../lib/adminApi';

export default function AdminAlbumList() {
  const [albums, setAlbums] = useState<Album[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi.getAlbums()
      .then(rows => setAlbums(rows.sort((a, b) => (a.release_year ?? 0) - (b.release_year ?? 0))))
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, []);

  return (
    <div>
      <div className="flex items-center justify-between mb-6">
        <h1 className="text-2xl font-bold text-white">Albums</h1>
        <Link to="/admin/albums/new" className={primaryBtn}>+ New Album</Link>
      </div>

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
              {albums.map(a => (
                <tr key={a.id} className="border-b border-gray-800 last:border-0 hover:bg-gray-800 transition-colors">
                  <td className="px-4 py-3 text-gray-100">{a.title}</td>
                  <td className="px-4 py-3 text-gray-400">{a.album_type ?? '—'}</td>
                  <td className="px-4 py-3 text-gray-400">{a.release_year ?? '—'}</td>
                  <td className="px-4 py-3 text-right">
                    <Link to={`/admin/albums/${a.id}`} className="text-indigo-400 hover:text-indigo-300 text-xs">
                      Edit
                    </Link>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </div>
  );
}

function Spinner() {
  return <div className="flex justify-center py-12"><div className="w-6 h-6 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}

const primaryBtn = 'text-sm bg-indigo-600 hover:bg-indigo-500 text-white rounded px-4 py-2 transition-colors';
