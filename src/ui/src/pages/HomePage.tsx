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
  if (albums.length === 0) return <p className="text-ink-muted">No albums yet.</p>;

  return (
    <div>
      <div className="mb-5">
        <h1 className="text-hug text-[2rem] font-bold">Discography</h1>
      </div>
      {/* gap-px + bg-ink creates 1px ink-coloured borders between every card */}
      <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-5 gap-px bg-ink border border-ink">
        {albums.map(a => <AlbumCard key={a.id} album={a} />)}
      </div>
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

function ErrorMsg({ message }: { message: string }) {
  return <p className="text-ember py-8">Failed to load: {message}</p>;
}
