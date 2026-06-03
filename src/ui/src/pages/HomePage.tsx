import { useEffect, useState } from 'react';
import { api } from '../api/client';
import type { Album } from '../api/types';
import AlbumCard from '../components/AlbumCard';

export default function HomePage() {
  const [albums, setAlbums] = useState<Album[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    api.getAlbums({ sort: 'release_year' })
      .then(setAlbums)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, []);

  if (loading) return <Spinner />;
  if (error)   return <ErrorMsg message={error} />;
  if (albums.length === 0) return <p className="text-gray-500">No albums yet.</p>;

  return (
    <div>
      <h1 className="text-2xl font-bold text-white mb-6">Discography</h1>
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-4">
        {albums.map(a => <AlbumCard key={a.id} album={a} />)}
      </div>
    </div>
  );
}

function Spinner() {
  return (
    <div className="flex justify-center py-20">
      <div className="w-8 h-8 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" />
    </div>
  );
}

function ErrorMsg({ message }: { message: string }) {
  return <p className="text-red-400 py-8">Failed to load: {message}</p>;
}
