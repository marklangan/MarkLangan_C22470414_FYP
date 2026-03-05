'use strict';

const request = require('supertest');
const app = require('./index');

// ── /health ──────────────────────────────────────────────────────────────────
describe('GET /health', () => {
  it('returns HTTP 200', async () => {
    const res = await request(app).get('/health');
    expect(res.statusCode).toBe(200);
  });

  it('returns status: ok', async () => {
    const res = await request(app).get('/health');
    expect(res.body.status).toBe('ok');
  });

  it('returns a valid ISO timestamp in the time field', async () => {
    const res = await request(app).get('/health');
    expect(res.body.time).toBeDefined();
    expect(new Date(res.body.time).toString()).not.toBe('Invalid Date');
  });

  it('returns a version field', async () => {
    const res = await request(app).get('/health');
    expect(res.body.version).toBeDefined();
  });

  it('returns JSON content-type', async () => {
    const res = await request(app).get('/health');
    expect(res.headers['content-type']).toMatch(/application\/json/);
  });
});

// ── /ready ───────────────────────────────────────────────────────────────────
describe('GET /ready', () => {
  it('returns HTTP 200', async () => {
    const res = await request(app).get('/ready');
    expect(res.statusCode).toBe(200);
  });

  it('returns ready: true', async () => {
    const res = await request(app).get('/ready');
    expect(res.body.ready).toBe(true);
  });
});

// ── 404 catch-all ─────────────────────────────────────────────────────────────
describe('Unknown routes', () => {
  it('returns HTTP 404 for an unknown path', async () => {
    const res = await request(app).get('/does-not-exist');
    expect(res.statusCode).toBe(404);
  });

  it('returns an error field on 404', async () => {
    const res = await request(app).get('/does-not-exist');
    expect(res.body.error).toBeDefined();
  });
});