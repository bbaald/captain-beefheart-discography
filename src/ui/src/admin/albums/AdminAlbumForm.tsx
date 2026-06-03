import { useEffect, useState, type FormEvent } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { adminApi, type AlbumDetail } from '../../lib/adminApi';
import AlbumTrackEditor from '../relationships/AlbumTrackEditor';
import { Field, Spinner, inputCls, primaryBtn } from '../formUtils';

const ALBUM_TYPES = ['studio', 'live', 'compilation', 'ep', 'single', 'box_set'];

export default function AdminAlbumForm() {
  const { id }    = useParams<{ id: string }>();
  const isNew     = id === 'new';
  const navigate  = useNavigate();

  const [album, setAlbum]     = useState<AlbumDetail | null>(null);
  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving]   = useState(false);
  const [error, setError]     = useState<string | null>(null);

  const [title, setTitle]           = useState('');
  const [creditedAs, setCreditedAs] = useState('');
  const [albumType, setAlbumType]   = useState('');
  const [releaseYear, setReleaseYear] = useState('');
  const [coverArtUrl, setCoverArtUrl] = useState('');

  function populate(a: AlbumDetail) {
    setAlbum(a);
    setTitle(a.title);
    setCreditedAs(a.credited_as ?? '');
    setAlbumType(a.album_type ?? '');
    setReleaseYear(a.release_year != null ? String(a.release_year) : '');
    setCoverArtUrl(a.cover_art_url ?? '');
  }

  useEffect(() => {
    if (isNew) return;
    adminApi.getAlbum(id!)
      .then(populate)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [id, isNew]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true); setError(null);
    try {
      const artistId = isNew ? await adminApi.getArtistId() : album!.artist_id;
      const body = {
        artist_id:   artistId,
        title:       title.trim(),
        ...(creditedAs.trim()   && { credited_as:   creditedAs.trim() }),
        ...(albumType           && { album_type:     albumType }),
        ...(releaseYear         && { release_year:   Number(releaseYear) }),
        ...(coverArtUrl.trim()  && { cover_art_url:  coverArtUrl.trim() }),
      };
      if (isNew) {
        const created = await adminApi.createAlbum(body);
        navigate(`/admin/albums/${created.id}`, { replace: true });
      } else {
        await adminApi.updateAlbum(id!, body);
        adminApi.getAlbum(id!).then(populate).catch(() => null);
      }
    } catch (e) { setError(String(e)); }
    finally { setSaving(false); }
  }

  async function handleDelete() {
    if (!confirm(`Delete "${album?.title}"? This cannot be undone.`)) return;
    setSaving(true);
    try {
      await adminApi.deleteAlbum(id!);
      navigate('/admin/albums', { replace: true });
    } catch (e) { setError(String(e)); setSaving(false); }
  }

  if (loading) return <Spinner />;

  return (
    <div>
      <div className="flex items-center gap-2 mb-6">
        <Link to="/admin/albums" className="text-gray-500 hover:text-gray-300 text-sm transition-colors">
          Albums
        </Link>
        <span className="text-gray-700">/</span>
        <h1 className="text-2xl font-bold text-white">
          {isNew ? 'New Album' : (album?.title ?? 'Edit Album')}
        </h1>
      </div>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      <form onSubmit={handleSubmit} className="bg-gray-900 rounded-lg p-6 mb-6">
        <div className="grid gap-4">
          <Field label="Title *">
            <input
              required
              value={title}
              onChange={e => setTitle(e.target.value)}
              className={inputCls}
            />
          </Field>

          <Field label="Credited as">
            <input
              value={creditedAs}
              onChange={e => setCreditedAs(e.target.value)}
              placeholder="Leave blank to use artist default"
              className={inputCls}
            />
          </Field>

          <div className="grid grid-cols-2 gap-4">
            <Field label="Type">
              <select
                value={albumType}
                onChange={e => setAlbumType(e.target.value)}
                className={inputCls}
              >
                <option value="">— none —</option>
                {ALBUM_TYPES.map(t => (
                  <option key={t} value={t}>{t}</option>
                ))}
              </select>
            </Field>

            <Field label="Release year">
              <input
                type="number"
                value={releaseYear}
                onChange={e => setReleaseYear(e.target.value)}
                placeholder="e.g. 1967"
                className={inputCls}
              />
            </Field>
          </div>

          <Field label="Cover art URL">
            <input
              type="url"
              value={coverArtUrl}
              onChange={e => setCoverArtUrl(e.target.value)}
              placeholder="https://…"
              className={inputCls}
            />
          </Field>
        </div>

        <div className="mt-6 flex items-center gap-3">
          <button type="submit" disabled={saving} className={primaryBtn}>
            {saving ? 'Saving…' : isNew ? 'Create album' : 'Save changes'}
          </button>
          <Link to="/admin/albums" className="text-sm text-gray-400 hover:text-white transition-colors">
            Cancel
          </Link>
          {!isNew && (
            <button
              type="button"
              onClick={handleDelete}
              disabled={saving}
              className="ml-auto text-sm text-red-500 hover:text-red-400 disabled:opacity-40 transition-colors"
            >
              Delete album
            </button>
          )}
        </div>
      </form>

      {!isNew && album && (
        <div className="bg-gray-900 rounded-lg p-6">
          <AlbumTrackEditor
            albumId={id!}
            tracks={album.songs}
            onRefresh={() =>
              adminApi.getAlbum(id!).then(populate).catch(e => setError(String(e)))
            }
          />
        </div>
      )}
    </div>
  );
}
