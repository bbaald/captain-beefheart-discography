import { FormEvent, useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { setApiKey, clearApiKey } from '../lib/adminAuth';
import { adminApi } from '../lib/adminApi';

export default function AdminLogin() {
  const [key, setKey]       = useState('');
  const [error, setError]   = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const navigate = useNavigate();

  async function handleSubmit(e: FormEvent) {
    e.preventDefault();
    if (!key.trim()) return;
    setLoading(true);
    setError(null);
    try {
      setApiKey(key.trim());
      await adminApi.validateKey();
      navigate('/admin');
    } catch {
      clearApiKey();
      setError('Invalid API key — try again.');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="min-h-screen bg-gray-950 flex items-center justify-center px-4">
      <div className="w-full max-w-sm">
        <h1 className="text-2xl font-bold text-white mb-1">Admin</h1>
        <p className="text-sm text-gray-500 mb-8">Enter your API key to continue.</p>

        <form onSubmit={handleSubmit} className="space-y-4">
          <input
            type="password"
            value={key}
            onChange={e => setKey(e.target.value)}
            placeholder="disc_…"
            autoComplete="off"
            className="w-full bg-gray-800 text-gray-100 text-sm rounded px-3 py-2.5 focus:outline-none focus:ring-1 focus:ring-indigo-500 placeholder-gray-600"
          />
          {error && <p className="text-sm text-red-400">{error}</p>}
          <button
            type="submit"
            disabled={loading || !key.trim()}
            className="w-full bg-indigo-600 hover:bg-indigo-500 disabled:opacity-50 text-white text-sm font-medium rounded px-4 py-2.5 transition-colors"
          >
            {loading ? 'Checking…' : 'Sign in'}
          </button>
        </form>

        <p className="mt-6 text-center text-xs text-gray-600">
          <a href="/" className="hover:text-gray-400 transition-colors">← Public site</a>
        </p>
      </div>
    </div>
  );
}
