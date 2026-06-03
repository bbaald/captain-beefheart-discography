import type { ReactNode } from 'react';

export const inputCls =
  'w-full bg-gray-800 text-sm text-gray-100 rounded px-3 py-2 focus:outline-none focus:ring-1 focus:ring-indigo-500 placeholder-gray-600';

export const primaryBtn =
  'text-sm bg-indigo-600 hover:bg-indigo-500 disabled:opacity-40 text-white rounded px-4 py-2 transition-colors';

export function Field({
  label,
  description,
  children,
}: {
  label: string;
  description?: string;
  children: ReactNode;
}) {
  return (
    <div>
      <label className="block text-xs text-gray-500 mb-1">{label}</label>
      {description && <p className="text-xs text-gray-600 mb-1">{description}</p>}
      {children}
    </div>
  );
}

export function Spinner() {
  return (
    <div className="flex justify-center py-12">
      <div className="w-6 h-6 rounded-full border-2 border-gray-700 border-t-indigo-400 animate-spin" />
    </div>
  );
}
