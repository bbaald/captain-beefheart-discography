import { useEffect, useState } from 'react';
import { api } from '../api/client';
import type { Artist } from '../api/types';

export default function ArtistPage() {
  const [artist, setArtist] = useState<Artist | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    api.getArtists()
      .then(artists => setArtist(artists[0] ?? null))
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Spinner />;
  if (error)   return <ErrorMsg message={error} />;
  if (!artist) return <p className="text-gray-500">No artist record found.</p>;

  return (
    <div className="max-w-xl">
      <h1 className="text-3xl font-bold text-white mb-2">{artist.name}</h1>

      {artist.aliases.length > 0 && (
        <div className="mt-6">
          <h2 className="text-xs text-gray-500 uppercase tracking-widest mb-3">Also performs as</h2>
          <ul className="space-y-1">
            {artist.aliases.map(alias => (
              <li key={alias} className="text-gray-300">{alias}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}

function Spinner() {
  return <div className="flex justify-center py-20"><div className="w-8 h-8 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" /></div>;
}
function ErrorMsg({ message }: { message: string }) {
  return <p className="text-red-400 py-8">Failed to load: {message}</p>;
}
