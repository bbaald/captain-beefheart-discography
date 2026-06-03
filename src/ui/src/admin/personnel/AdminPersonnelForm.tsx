import { useEffect, useState, type FormEvent } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import { adminApi, type PersonnelRow } from '../../lib/adminApi';
import { Field, Spinner, inputCls, primaryBtn } from '../formUtils';

export default function AdminPersonnelForm() {
  const { id }    = useParams<{ id: string }>();
  const isNew     = id === 'new';
  const navigate  = useNavigate();

  const [person, setPerson]   = useState<PersonnelRow | null>(null);
  const [loading, setLoading] = useState(!isNew);
  const [saving, setSaving]   = useState(false);
  const [error, setError]     = useState<string | null>(null);

  const [name, setName]       = useState('');
  const [sortName, setSortName] = useState('');

  useEffect(() => {
    if (isNew) return;
    adminApi.getPersonnel(id!)
      .then(p => {
        setPerson(p);
        setName(p.name);
        setSortName(p.sort_name ?? '');
      })
      .catch(e => setError(String(e)))
      .finally(() => setLoading(false));
  }, [id, isNew]);

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    setSaving(true); setError(null);
    try {
      const body = {
        name: name.trim(),
        ...(sortName.trim() && { sort_name: sortName.trim() }),
      };
      if (isNew) {
        const created = await adminApi.createPersonnel(body);
        navigate(`/admin/personnel/${created.id}`, { replace: true });
      } else {
        const updated = await adminApi.updatePersonnel(id!, body);
        setPerson(updated);
      }
    } catch (e) { setError(String(e)); }
    finally { setSaving(false); }
  }

  async function handleDelete() {
    if (!confirm(`Delete "${person?.name}"? This cannot be undone.`)) return;
    setSaving(true);
    try {
      await adminApi.deletePersonnel(id!);
      navigate('/admin/personnel', { replace: true });
    } catch (e) { setError(String(e)); setSaving(false); }
  }

  if (loading) return <Spinner />;

  return (
    <div>
      <div className="flex items-center gap-2 mb-6">
        <Link to="/admin/personnel" className="text-gray-500 hover:text-gray-300 text-sm transition-colors">
          Personnel
        </Link>
        <span className="text-gray-700">/</span>
        <h1 className="text-2xl font-bold text-white">
          {isNew ? 'New Person' : (person?.name ?? 'Edit Person')}
        </h1>
      </div>

      {error && <p className="text-red-400 text-sm mb-4">{error}</p>}

      <form onSubmit={handleSubmit} className="bg-gray-900 rounded-lg p-6">
        <div className="grid gap-4">
          <Field label="Name *">
            <input
              required
              value={name}
              onChange={e => setName(e.target.value)}
              className={inputCls}
            />
          </Field>

          <Field
            label="Sort name"
            description={'Used for alphabetical sorting, e.g. “Vliet, Don”'}
          >
            <input
              value={sortName}
              onChange={e => setSortName(e.target.value)}
              placeholder="e.g. Vliet, Don"
              className={inputCls}
            />
          </Field>
        </div>

        <div className="mt-6 flex items-center gap-3">
          <button type="submit" disabled={saving} className={primaryBtn}>
            {saving ? 'Saving…' : isNew ? 'Create person' : 'Save changes'}
          </button>
          <Link to="/admin/personnel" className="text-sm text-gray-400 hover:text-white transition-colors">
            Cancel
          </Link>
          {!isNew && (
            <button
              type="button"
              onClick={handleDelete}
              disabled={saving}
              className="ml-auto text-sm text-red-500 hover:text-red-400 disabled:opacity-40 transition-colors"
            >
              Delete person
            </button>
          )}
        </div>
      </form>
    </div>
  );
}
