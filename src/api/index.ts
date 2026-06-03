import express, { Request, Response, NextFunction } from 'express';
import adminRouter from './routes/admin';
import artistsRouter from './routes/artists';
import albumsRouter from './routes/albums';
import songsRouter from './routes/songs';
import personnelRouter from './routes/personnel';
import songAlbumsRouter from './routes/song-albums';
import songPersonnelRouter from './routes/song-personnel';
import searchRouter from './routes/search';
import mcpRouter from '../mcp/router';

const app = express();
app.use(express.json());

app.use('/admin/api-keys', adminRouter);
app.use('/api/v1/artists', artistsRouter);
app.use('/api/v1/albums', albumsRouter);
app.use('/api/v1/songs', songAlbumsRouter);
app.use('/api/v1/songs', songPersonnelRouter);
app.use('/api/v1/songs', songsRouter);
app.use('/api/v1/personnel', personnelRouter);
app.use('/api/v1/search', searchRouter);
app.use('/mcp', mcpRouter);

app.use((err: Error, _req: Request, res: Response, _next: NextFunction) => {
  console.error(err);
  res.status(500).json({ error: 'Internal server error', code: 'INTERNAL_ERROR' });
});

export default app;
