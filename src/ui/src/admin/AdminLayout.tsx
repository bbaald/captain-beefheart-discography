import { NavLink, Outlet, useNavigate } from 'react-router-dom';
import { clearApiKey } from '../lib/adminAuth';

const navLink = ({ isActive }: { isActive: boolean }) =>
  isActive
    ? 'text-white text-sm font-medium'
    : 'text-gray-400 hover:text-white text-sm transition-colors';

export default function AdminLayout() {
  const navigate = useNavigate();

  function logout() {
    clearApiKey();
    navigate('/admin/login');
  }

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100">
      <header className="sticky top-0 z-10 bg-gray-900 border-b border-gray-800">
        <div className="max-w-5xl mx-auto px-4 h-14 flex items-center gap-6">
          <span className="font-semibold text-white tracking-tight text-sm shrink-0 flex items-center gap-2">
            Discography
            <span className="text-xs bg-indigo-600 text-white px-1.5 py-0.5 rounded font-normal">Admin</span>
          </span>

          <nav className="flex items-center gap-4">
            <NavLink to="/admin"        end className={navLink}>Dashboard</NavLink>
            <NavLink to="/admin/albums"     className={navLink}>Albums</NavLink>
            <NavLink to="/admin/songs"      className={navLink}>Songs</NavLink>
            <NavLink to="/admin/personnel"  className={navLink}>Personnel</NavLink>
          </nav>

          <div className="ml-auto flex items-center gap-4">
            <a href="/" className="text-xs text-gray-500 hover:text-gray-300 transition-colors">
              Public site
            </a>
            <button
              onClick={logout}
              className="text-xs text-gray-400 hover:text-white transition-colors"
            >
              Sign out
            </button>
          </div>
        </div>
      </header>

      <main className="max-w-5xl mx-auto px-4 py-8">
        <Outlet />
      </main>
    </div>
  );
}
