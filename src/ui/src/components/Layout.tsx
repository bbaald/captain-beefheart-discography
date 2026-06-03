import { Link, NavLink, Outlet, useNavigate } from 'react-router-dom';
import { FormEvent, useState } from 'react';

export default function Layout() {
  const [q, setQ] = useState('');
  const navigate = useNavigate();

  function handleSearch(e: FormEvent) {
    e.preventDefault();
    if (q.trim()) navigate(`/search?q=${encodeURIComponent(q.trim())}`);
  }

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100">
      <header className="sticky top-0 z-10 bg-gray-900 border-b border-gray-800">
        <div className="max-w-5xl mx-auto px-4 h-14 flex items-center gap-6">
          <Link to="/" className="font-semibold text-white tracking-tight shrink-0">
            Discography
          </Link>
          <nav className="flex items-center gap-4 text-sm">
            <NavLink to="/"       end className={({ isActive }) => isActive ? 'text-white' : 'text-gray-400 hover:text-white'}>Albums</NavLink>
            <span className="text-gray-400">Captain Beefheart</span>
          </nav>
          <form onSubmit={handleSearch} className="ml-auto flex items-center gap-2">
            <input
              value={q}
              onChange={e => setQ(e.target.value)}
              placeholder="Search…"
              className="bg-gray-800 text-sm text-gray-100 placeholder-gray-500 rounded px-3 py-1.5 w-48 focus:outline-none focus:ring-1 focus:ring-gray-600"
            />
            <button type="submit" className="text-sm text-gray-400 hover:text-white px-2">Go</button>
          </form>
        </div>
      </header>
      <main className="max-w-5xl mx-auto px-4 py-8">
        <Outlet />
      </main>
    </div>
  );
}
