import { useEffect, useState, FormEvent } from 'react';
import { Link, useSearchParams } from 'react-router-dom';
import { api } from '../api/client';
import type { SearchResults } from '../api/types';

export default function SearchPage() {
  const [searchParams, setSearchParams] = useSearchParams();
  const q = searchParams.get('q') ?? '';
  const [input, setInput] = useState(q);
  const [results, setResults] = useState<SearchResults | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    setInput(q);
    if (!q.trim()) { setResults(null); return; }
    setLoading(true);
    setError(null);
    api.search(q)
      .then(setResults)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [q]);

  function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (input.trim()) setSearchParams({ q: input.trim() });
  }

  const totalCount =
    (results?.results.songs.length ?? 0) + (results?.results.albums.length ?? 0);

  return (
    <div>
      <div className="mb-6">
        <h1 className="text-hug text-[2rem] font-bold">Search</h1>
      </div>

      <form onSubmit={handleSubmit} className="flex mb-8">
        <input
          value={input}
          onChange={e => setInput(e.target.value)}
          placeholder="Search songs and albums…"
          className="flex-1 bg-canvas-muted border border-ink text-ink text-[0.875rem] placeholder-ink-muted px-4 py-2 focus:outline-none focus:bg-canvas-strong"
        />
        <button
          type="submit"
          className="bg-canvas-strong border border-ink border-l-0 text-ink-brown text-[0.8rem] font-medium uppercase tracking-[0.06em] px-4 py-2 hover:bg-ember hover:text-canvas hover:border-ember transition-colors"
        >
          Search
        </button>
      </form>

      {loading && <Spinner />}
      {error   && <p className="text-ember">Failed to search: {error}</p>}

      {results && !loading && (
        <div>
          <p className="text-[0.75rem] text-ink-muted mb-5">
            {totalCount === 0
              ? `No results for "${results.query}"`
              : `${totalCount} result${totalCount !== 1 ? 's' : ''} for "${results.query}"`}
          </p>

          {results.results.songs.length > 0 && (
            <section className="mb-7">
              <h2 className="text-[0.62rem] uppercase tracking-[0.1em] text-ink-muted font-medium mb-3">
                Songs
              </h2>
              <ul className="divide-y divide-[#d4c8b0]">
                {results.results.songs.map(s => (
                  <li key={s.id} className="flex items-baseline gap-3 py-2">
                    <Link
                      to={`/songs/${s.id}`}
                      className="font-serif text-[0.95rem] text-ink hover:text-ember"
                    >
                      {s.name}
                    </Link>
                    {s.release_year && (
                      <span className="text-[0.72rem] text-ink-muted">{s.release_year}</span>
                    )}
                  </li>
                ))}
              </ul>
            </section>
          )}

          {results.results.albums.length > 0 && (
            <section className="mb-7">
              <h2 className="text-[0.62rem] uppercase tracking-[0.1em] text-ink-muted font-medium mb-3">
                Albums
              </h2>
              <ul className="divide-y divide-[#d4c8b0]">
                {results.results.albums.map(a => (
                  <li key={a.id} className="flex items-baseline gap-3 py-2">
                    <Link
                      to={`/albums/${a.id}`}
                      className="font-serif text-[0.95rem] text-ink hover:text-ember"
                    >
                      {a.name}
                    </Link>
                    {a.release_year && (
                      <span className="text-[0.72rem] text-ink-muted">{a.release_year}</span>
                    )}
                  </li>
                ))}
              </ul>
            </section>
          )}

          {totalCount === 0 && (
            <p className="text-ink-muted">Try a different search term.</p>
          )}
        </div>
      )}

      {!q && !loading && (
        <p className="text-[0.875rem] text-ink-muted">Enter a search term above.</p>
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
