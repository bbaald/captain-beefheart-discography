import { useEffect, useState } from 'react';
import { adminApi, type Song, type SongRow } from '../../lib/adminApi';

interface Props {
  albumId: string;
  tracks: SongRow[];
  onRefresh: () => void;
}

export default function AlbumTrackEditor({ albumId, tracks, onRefresh }: Props) {
  const [allSongs, setAllSongs]   = useState<Song[]>([]);
  const [selectedId, setSelectedId] = useState('');
  const [seqNum, setSeqNum]       = useState('');
  const [busy, setBusy]           = useState(false);
  const [error, setError]         = useState<string | null>(null);

  useEffect(() => {
    adminApi.getSongs()
      .then(rows => setAllSongs(rows.sort((a, b) => a.title.localeCompare(b.title))))
      .catch(e => setError(String(e)));
  }, []);

  const sorted    = [...tracks].sort((a, b) => a.sequence_number - b.sequence_number);
  const trackIds  = new Set(tracks.map(t => t.id));
  const available = allSongs.filter(s => !trackIds.has(s.id));

  async function addTrack() {
    if (!selectedId) return;
    setBusy(true); setError(null);
    try {
      const seq = seqNum ? Number(seqNum) : tracks.length + 1;
      await adminApi.addSongToAlbum(selectedId, albumId, seq);
      setSelectedId(''); setSeqNum('');
      onRefresh();
    } catch (e) { setError(String(e)); }
    finally { setBusy(false); }
  }

  async function removeTrack(songId: string) {
    setBusy(true); setError(null);
    try {
      await adminApi.removeSongFromAlbum(songId, albumId);
      onRefresh();
    } catch (e) { setError(String(e)); }
    finally { setBusy(false); }
  }

  return (
    <div>
      <h3 className="text-sm font-semibold text-gray-300 mb-3">Tracks</h3>

      {error && <p className="text-red-400 text-xs mb-2">{error}</p>}

      <div className="bg-gray-950 rounded-lg overflow-hidden mb-4">
        {sorted.length === 0 ? (
          <p className="text-gray-600 text-xs text-center py-4">No tracks yet.</p>
        ) : (
          <table className="w-full text-xs">
            <tbody>
              {sorted.map(t => (
                <tr key={t.id} className="border-b border-gray-800 last:border-0">
                  <td className="px-3 py-2 text-gray-500 w-8 tabular-nums">{t.sequence_number}</td>
                  <td className="px-3 py-2 text-gray-200">{t.title}</td>
                  <td className="px-3 py-2 text-gray-500">{t.recording_type ?? ''}</td>
                  <td className="px-3 py-2 text-right">
                    <button
                      onClick={() => removeTrack(t.id)}
                      disabled={busy}
                      className="text-red-500 hover:text-red-400 disabled:opacity-40 transition-colors"
                    >
                      Remove
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        )}
      </div>

      <div className="flex gap-2 items-end">
        <div className="flex-1">
          <label className="block text-xs text-gray-500 mb-1">Add song</label>
          <select
            value={selectedId}
            onChange={e => setSelectedId(e.target.value)}
            className="w-full bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500"
          >
            <option value="">— select —</option>
            {available.map(s => (
              <option key={s.id} value={s.id}>{s.title}</option>
            ))}
          </select>
        </div>

        <div className="w-20">
          <label className="block text-xs text-gray-500 mb-1">Track #</label>
          <input
            type="number"
            value={seqNum}
            onChange={e => setSeqNum(e.target.value)}
            placeholder={String(tracks.length + 1)}
            className="w-full bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500 placeholder-gray-600"
          />
        </div>

        <button
          onClick={addTrack}
          disabled={busy || !selectedId}
          className="bg-indigo-600 hover:bg-indigo-500 disabled:opacity-40 text-white text-sm rounded px-4 py-2 transition-colors"
        >
          Add
        </button>
      </div>
    </div>
  );
}
