import path from 'path';
import express from 'express';
import { initPool } from './db/client';
import app from './api/index';

async function start() {
  await initPool();

  // Serve built UI in production (must come after API routes in app)
  if (process.env.NODE_ENV === 'production') {
    const uiDist = path.join(__dirname, '../src/ui/dist');
    app.use(express.static(uiDist));
    app.get('*', (_req, res) => {
      res.sendFile(path.join(uiDist, 'index.html'));
    });
  }

  const port = Number(process.env.PORT ?? 3000);
  app.listen(port, () => {
    console.log(`Discography API listening on port ${port}`);
  });
}

start().catch(err => {
  console.error('Failed to start server:', err);
  process.exit(1);
});
