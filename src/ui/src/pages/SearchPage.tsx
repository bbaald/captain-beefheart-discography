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

  const totalCount = (results?.results.songs.length ?? 0) + (results?.results.albums.length ?? 0);

  return (
    <div>
      <h1 className="text-2xl font-bold text-white mb-6">Search</h1>

      <form onSubmit={handleSubmit} className="flex gap-2 mb-8">
        <input
          value={input}
          onChange={e => setInput(e.target.value)}
          placeholder="Search songs and albums…"
          className="flex-1 bg-gray-900 text-gray-100 placeholder-gray-500 rounded px-4 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        />
        <button type="submit" className="bg-indigo-600 hover:bg-indigo-500 text-white px-4 py-2 rounded text-sm">Search</button>
      </form>

      {loading && <Spinner />}
      {error   && <p className="text-red-400">Failed to search: {error}</p>}

      {results && !loading && (
        <div>
          <p className="text-sm text-gray-500 mb-6">
            {totalCount === 0 ? `No results for "${results.query}"` : `${totalCount} result${totalCount !== 1 ? 's' : ''} for "${results.query}"`}
          </p>

          {results.results.songs.length > 0 && (
            <section className="mb-8">
              <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Songs</h2>
              <ul className="space-y-2">
                {results.results.songs.map(s => (
                  <li key={s.id} className="flex items-center gap-3">
                    <Link to={`/songs/${s.id}`} className="text-white hover:text-indigo-400">{s.name}</Link>
                    {s.release_year && <span className="text-sm text-gray-500">{s.release_year}</span>}
                  </li>
                ))}
              </ul>
            </section>
          )}

          {results.results.albums.length > 0 && (
            <section>
              <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Albums</h2>
              <ul className="space-y-2">
                {results.results.albums.map(a => (
                  <li key={a.id} className="flex items-center gap-3">
                    <Link to={`/albums/${a.id}`} className="text-white hover:text-indigo-400">{a.name}</Link>
                    {a.release_year && <span className="text-sm text-gray-500">{a.release_year}</span>}
                  </li>
                ))}
              </ul>
            </section>
          )}

          {totalCount === 0 && (
            <p className="text-gray-500">Try a different search term.</p>
          )}
        </div>
      )}

      {!q && !loading && (
        <p className="text-gray-500">Enter a search term above.</p>
      )}
    </div>
  );
}

function Spinner() {
  return <div className="flex justify-center py-20"><div className="w-8 h-8 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}
