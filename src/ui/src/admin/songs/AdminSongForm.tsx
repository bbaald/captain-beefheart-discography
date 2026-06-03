import { useEffect, useState, type FormEvent } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { adminApi, type SongDetail } from '../../lib/adminApi';
import SongPersonnelEditor from '../relationships/SongPersonnelEditor';
import { Field, Spinner, inputCls, primaryBtn } from '../formUtils';

const MEDIA_TYPES     = ['audio', 'video'];
const RECORDING_TYPES = ['studio', 'live', 'demo', 'rehearsal', 'interview', 'other'];

export default function AdminSongForm() {
  const { id }    = useParams<{ id: string }>();
  const isNew     = id === 'new';
  const navigate  = useNavigate();

  const [song, setSong]       = useState<SongDetail | null>(null);
  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving]   = useState(false);
  const [error, setError]     = useState<string | null>(null);

  const [title, setTitle]             = useState('');
  const [creditedAs, setCreditedAs]   = useState('');
  const [mediaType, setMediaType]     = useState('audio');
  const [recordingType, setRecordingType] = useState('');
  const [releaseYear, setReleaseYear] = useState('');
  const [recordingUrl, setRecordingUrl] = useState('');
  // Create-only required fields
  const [runningTime, setRunningTime] = useState('');
  const [sourceList, setSourceList]   = useState('');

  function populate(s: SongDetail) {
    setSong(s);
    setTitle(s.title);
    setCreditedAs(s.credited_as ?? '');
    setMediaType(s.media_type ?? 'audio');
    setRecordingType(s.recording_type ?? '');
    setReleaseYear(s.release_year != null ? String(s.release_year) : '');
    setRecordingUrl(s.recording_url ?? '');
  }

  useEffect(() => {
    if (isNew) return;
    adminApi.getSong(id!)
      .then(populate)
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [id, isNew]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true); setError(null);
    try {
      if (isNew) {
        const artistId = await adminApi.getArtistId();
        const sources  = sourceList.split(',').map(s => s.trim()).filter(Boolean);
        const body = {
          artist_id:            artistId,
          title:                title.trim(),
          media_type:           mediaType,
          running_time_seconds: Number(runningTime),
          release_year:         Number(releaseYear),
          source_list:          sources,
          ...(creditedAs.trim()   && { credited_as:    creditedAs.trim() }),
          ...(recordingType       && { recording_type: recordingType }),
          ...(recordingUrl.trim() && { recording_url:  recordingUrl.trim() }),
        };
        const created = await adminApi.createSong(body);
        navigate(`/admin/songs/${created.id}`, { replace: true });
      } else {
        const body = {
          title:          title.trim(),
          media_type:     mediaType,
          credited_as:    creditedAs.trim() || null,
          recording_type: recordingType     || null,
          release_year:   releaseYear       ? Number(releaseYear) : null,
          recording_url:  recordingUrl.trim() || null,
        };
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        await adminApi.updateSong(id!, body as any);
        adminApi.getSong(id!).then(populate).catch(() => null);
      }
    } catch (e) { setError(String(e)); }
    finally { setSaving(false); }
  }

  async function handleDelete() {
    if (!confirm(`Delete "${song?.title}"? This cannot be undone.`)) return;
    setSaving(true);
    try {
      await adminApi.deleteSong(id!);
      navigate('/admin/songs', { replace: true });
    } catch (e) { setError(String(e)); setSaving(false); }
  }

  if (loading) return <Spinner />;

  return (
    <div>
      <div className="flex items-center gap-2 mb-6">
        <Link to="/admin/songs" className="text-gray-500 hover:text-gray-300 text-sm transition-colors">
          Songs
        </Link>
        <span className="text-gray-700">/</span>
        <h1 className="text-2xl font-bold text-white">
          {isNew ? 'New Song' : (song?.title ?? 'Edit Song')}
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
            <Field label="Media type">
              <select
                value={mediaType}
                onChange={e => setMediaType(e.target.value)}
                className={inputCls}
              >
                {MEDIA_TYPES.map(t => (
                  <option key={t} value={t}>{t}</option>
                ))}
              </select>
            </Field>

            <Field label="Recording type">
              <select
                value={recordingType}
                onChange={e => setRecordingType(e.target.value)}
                className={inputCls}
              >
                <option value="">— none —</option>
                {RECORDING_TYPES.map(t => (
                  <option key={t} value={t}>{t}</option>
                ))}
              </select>
            </Field>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <Field label="Release year">
              <input
                type="number"
                value={releaseYear}
                onChange={e => setReleaseYear(e.target.value)}
                placeholder="e.g. 1967"
                className={inputCls}
              />
            </Field>

            <Field label="Recording URL">
              <input
                type="url"
                value={recordingUrl}
                onChange={e => setRecordingUrl(e.target.value)}
                placeholder="https://music.apple.com/…"
                className={inputCls}
              />
            </Field>
          </div>

          {isNew && (
            <>
              <Field label="Running time (seconds) *">
                <input
                  required
                  type="number"
                  min="1"
                  value={runningTime}
                  onChange={e => setRunningTime(e.target.value)}
                  placeholder="e.g. 183"
                  className={inputCls}
                />
              </Field>

              <Field
                label="Source *"
                description="Comma-separated list of where this recording appears"
              >
                <input
                  required
                  value={sourceList}
                  onChange={e => setSourceList(e.target.value)}
                  placeholder="Safe As Milk LP"
                  className={inputCls}
                />
              </Field>
            </>
          )}
        </div>

        <div className="mt-6 flex items-center gap-3">
          <button type="submit" disabled={saving} className={primaryBtn}>
            {saving ? 'Saving…' : isNew ? 'Create song' : 'Save changes'}
          </button>
          <Link to="/admin/songs" className="text-sm text-gray-400 hover:text-white transition-colors">
            Cancel
          </Link>
          {!isNew && (
            <button
              type="button"
              onClick={handleDelete}
              disabled={saving}
              className="ml-auto text-sm text-red-500 hover:text-red-400 disabled:opacity-40 transition-colors"
            >
              Delete song
            </button>
          )}
        </div>
      </form>

      {!isNew && song && (
        <div className="bg-gray-900 rounded-lg p-6">
          <SongPersonnelEditor
            songId={id!}
            personnel={song.personnel}
            onRefresh={() =>
              adminApi.getSong(id!).then(populate).catch(e => setError(String(e)))
            }
          />
        </div>
      )}
    </div>
  );
}
