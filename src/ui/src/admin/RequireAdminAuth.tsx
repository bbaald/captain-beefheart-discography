import { Navigate, Outlet } from 'react-router-dom';
import { getApiKey } from '../lib/adminAuth';

export default function RequireAdminAuth() {
  if (!getApiKey()) return <Navigate to="/admin/login" replace />;
  return <Outlet />;
}
