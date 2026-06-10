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
    <div className="min-h-screen bg-canvas text-ink">
      <header className="sticky top-0 z-10 bg-canvas-muted border-b border-ink">
        <div className="max-w-5xl mx-auto px-6 h-[50px] flex items-center gap-5">
          <Link
            to="/"
            className="font-serif font-bold text-[1.05rem] text-ink tracking-[-0.01em] shrink-0"
          >
            Captain Beefheart
          </Link>

          <nav className="flex items-center gap-2 text-[0.72rem] uppercase tracking-[0.06em] whitespace-nowrap">
            <NavLink
              to="/"
              end
              className={({ isActive }) =>
                isActive ? 'text-ink' : 'text-ink-muted hover:text-ink transition-colors'
              }
            >
              Albums
            </NavLink>
            <span className="text-amber-light select-none">·</span>
          </nav>

          <form onSubmit={handleSearch} className="ml-auto flex">
            <input
              value={q}
              onChange={e => setQ(e.target.value)}
              placeholder="Search…"
              className="bg-canvas border border-ink text-[0.78rem] text-ink placeholder-ink-muted px-[10px] py-[4px] w-44 focus:outline-none focus:bg-canvas-strong"
            />
            <button
              type="submit"
              className="bg-canvas-strong border border-ink border-l-0 text-ink-brown text-[0.68rem] font-medium uppercase tracking-[0.06em] px-[10px] py-[4px] hover:bg-canvas-muted transition-colors"
            >
              Go
            </button>
          </form>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-6 py-9">
        <Outlet />
      </main>
    </div>
  );
}
