import { BrowserRouter, Routes, Route } from 'react-router-dom';
import Layout from './components/Layout';
import HomePage from './pages/HomePage';
import AlbumPage from './pages/AlbumPage';
import SongPage from './pages/SongPage';
import SearchPage from './pages/SearchPage';
import ArtistPage from './pages/ArtistPage';

import AdminLogin       from './admin/AdminLogin';
import RequireAdminAuth from './admin/RequireAdminAuth';
import AdminLayout      from './admin/AdminLayout';
import AdminDashboard   from './admin/AdminDashboard';

import AdminAlbumList   from './admin/albums/AdminAlbumList';
import AdminAlbumForm   from './admin/albums/AdminAlbumForm';
import AdminSongList    from './admin/songs/AdminSongList';
import AdminSongForm    from './admin/songs/AdminSongForm';
import AdminPersonnelList from './admin/personnel/AdminPersonnelList';
import AdminPersonnelForm from './admin/personnel/AdminPersonnelForm';

export default function App() {
  return (
    <BrowserRouter>
      <Routes>
        {/* ── Public site ─────────────────────────────────────────────── */}
        <Route element={<Layout />}>
          <Route path="/"           element={<HomePage />} />
          <Route path="/albums/:id" element={<AlbumPage />} />
          <Route path="/songs/:id"  element={<SongPage />} />
          <Route path="/search"     element={<SearchPage />} />
          <Route path="/artist"     element={<ArtistPage />} />
        </Route>

        {/* ── Admin: login (no auth required) ─────────────────────────── */}
        <Route path="/admin/login" element={<AdminLogin />} />

        {/* ── Admin: protected ────────────────────────────────────────── */}
        <Route element={<RequireAdminAuth />}>
          <Route element={<AdminLayout />}>
            <Route path="/admin"                     element={<AdminDashboard />} />

            <Route path="/admin/albums"              element={<AdminAlbumList />} />
            <Route path="/admin/albums/:id"          element={<AdminAlbumForm />} />

            <Route path="/admin/songs"               element={<AdminSongList />} />
            <Route path="/admin/songs/:id"           element={<AdminSongForm />} />

            <Route path="/admin/personnel"           element={<AdminPersonnelList />} />
            <Route path="/admin/personnel/:id"       element={<AdminPersonnelForm />} />
          </Route>
        </Route>
      </Routes>
    </BrowserRouter>
  );
}
