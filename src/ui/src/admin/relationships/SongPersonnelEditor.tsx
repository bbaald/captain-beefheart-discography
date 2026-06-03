import { useEffect, useState } from 'react';
import { adminApi, type PersonnelRow } from '../../lib/adminApi';

interface Credit {
  id: string;
  name: string;
  role: string;
  instrument: string | null;
}

interface Props {
  songId: string;
  personnel: Credit[];
  onRefresh: () => void;
}

export default function SongPersonnelEditor({ songId, personnel, onRefresh }: Props) {
  const [allPeople, setAllPeople] = useState<PersonnelRow[]>([]);
  const [selectedId, setSelectedId] = useState('');
  const [role, setRole]           = useState('');
  const [busy, setBusy]           = useState(false);
  const [error, setError]         = useState<string | null>(null);

  useEffect(() => {
    adminApi.getAllPersonnel()
      .then(rows => setAllPeople(rows.sort((a, b) => a.name.localeCompare(b.name))))
      .catch(e => setError(String(e)));
  }, []);

  const creditedIds = new Set(personnel.map(c => c.id));
  const available   = allPeople.filter(p => !creditedIds.has(p.id));

  async function addCredit() {
    if (!selectedId || !role.trim()) return;
    setBusy(true); setError(null);
    try {
      await adminApi.addPersonnelToSong(songId, selectedId, role.trim());
      setSelectedId(''); setRole('');
      onRefresh();
    } catch (e) { setError(String(e)); }
    finally { setBusy(false); }
  }

  async function removeCredit(personnelId: string) {
    setBusy(true); setError(null);
    try {
      await adminApi.removePersonnelFromSong(songId, personnelId);
      onRefresh();
    } catch (e) { setError(String(e)); }
    finally { setBusy(false); }
  }

  return (
    <div>
      <h3 className="text-sm font-semibold text-gray-300 mb-3">Personnel</h3>

      {error && <p className="text-red-400 text-xs mb-2">{error}</p>}

      <div className="bg-gray-950 rounded-lg overflow-hidden mb-4">
        {personnel.length === 0 ? (
          <p className="text-gray-600 text-xs text-center py-4">No credits yet.</p>
        ) : (
          <table className="w-full text-xs">
            <tbody>
              {personnel.map(c => (
                <tr key={c.id} className="border-b border-gray-800 last:border-0">
                  <td className="px-3 py-2 text-gray-200">{c.name}</td>
                  <td className="px-3 py-2 text-gray-400">{c.role}</td>
                  <td className="px-3 py-2 text-gray-500">{c.instrument ?? ''}</td>
                  <td className="px-3 py-2 text-right">
                    <button
                      onClick={() => removeCredit(c.id)}
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
          <label className="block text-xs text-gray-500 mb-1">Person</label>
          <select
            value={selectedId}
            onChange={e => setSelectedId(e.target.value)}
            className="w-full bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500"
          >
            <option value="">— select —</option>
            {available.map(p => (
              <option key={p.id} value={p.id}>{p.name}</option>
            ))}
          </select>
        </div>

        <div className="flex-1">
          <label className="block text-xs text-gray-500 mb-1">Role</label>
          <input
            type="text"
            value={role}
            onChange={e => setRole(e.target.value)}
            placeholder="e.g. guitar, vocals, bass"
            className="w-full bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500 placeholder-gray-600"
          />
        </div>

        <button
          onClick={addCredit}
          disabled={busy || !selectedId || !role.trim()}
          className="bg-indigo-600 hover:bg-indigo-500 disabled:opacity-40 text-white text-sm rounded px-4 py-2 transition-colors"
        >
          Add
        </button>
      </div>
    </div>
  );
}
