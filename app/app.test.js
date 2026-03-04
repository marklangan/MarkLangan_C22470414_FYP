'use strict';

const request = require('supertest');
const app = require('./index');

// ── /health ──────────────────────────────────────────────────────────────────
describe('GET /health', () => {
  let res;
  beforeAll(async () => {
    res = await request(app).get('/health');
  });

  it('returns HTTP 200', () => {
    expect(res.statusCode).toBe(200);
  });

  it('returns status: ok', () => {
    expect(res.body.status).toBe('ok');
  });

  it('returns a valid ISO timestamp in the time field', () => {
    expect(res.body.time).toBeDefined();
    expect(new Date(res.body.time).toString()).not.toBe('Invalid Date');
  });

  it('returns a version field', () => {
    expect(res.body.version).toBe('unknown');
  });

  it('returns JSON content-type', () => {
    expect(res.headers['content-type']).toMatch(/application\/json/);
  });
});

// ── /ready ───────────────────────────────────────────────────────────────────
describe('GET /ready', () => {
  let res;
  beforeAll(async () => {
    res = await request(app).get('/ready');
  });

  it('returns HTTP 200', () => {
    expect(res.statusCode).toBe(200);
  });

  it('returns ready: true', () => {
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

  it('returns HTTP 404 for POST to a known path', async () => {
    const res = await request(app).post('/health');
    expect(res.statusCode).toBe(404);
  });
});
