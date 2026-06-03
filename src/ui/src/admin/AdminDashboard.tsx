import { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import { adminApi } from '../lib/adminApi';

export default function AdminDashboard() {
  const [stats, setStats] = useState<{ albums: number; songs: number; personnel: number } | null>(null);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    adminApi.getStats()
      .then(setStats)
      .catch(e => setError(String(e)));
  }, []);

  return (
    <div>
      <h1 className="text-2xl font-bold text-white mb-6">Dashboard</h1>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      <div className="grid grid-cols-3 gap-4 mb-10">
        {[
          { label: 'Albums',    value: stats?.albums,    href: '/admin/albums' },
          { label: 'Songs',     value: stats?.songs,     href: '/admin/songs' },
          { label: 'Personnel', value: stats?.personnel, href: '/admin/personnel' },
        ].map(({ label, value, href }) => (
          <Link
            key={label}
            to={href}
            className="bg-gray-900 rounded-lg p-5 hover:bg-gray-800 transition-colors"
          >
            <p className="text-3xl font-bold text-white mb-1">
              {value ?? <span className="text-gray-600">—</span>}
            </p>
            <p className="text-sm text-gray-400">{label}</p>
          </Link>
        ))}
      </div>

      <div className="flex gap-3">
        <Link to="/admin/albums/new"    className={btnClass}>+ New Album</Link>
        <Link to="/admin/songs/new"     className={btnClass}>+ New Song</Link>
        <Link to="/admin/personnel/new" className={btnClass}>+ New Person</Link>
      </div>
    </div>
  );
}

const btnClass =
  'text-sm bg-gray-800 hover:bg-gray-700 text-gray-200 rounded px-4 py-2 transition-colors';
