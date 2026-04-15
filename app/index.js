'use strict';

const express = require('express');
const app = express();
const port = process.env.PORT || 8080;
const APP_VERSION = process.env.APP_VERSION || 'unknown';

app.use(express.json());

// Health endpoint - used by Kubernetes liveness and readiness probes
app.get('/health', (req, res) => {
  res.status(200).json({
    status: 'ok',
    time: new Date().toISOString(),
    version: APP_VERSION,
  });
});

// Readiness endpoint - separate from liveness to allow take pod out of rotation
app.get('/ready', (req, res) => {
  res.status(200).json({ ready: true });
});

// Catch-all 404
app.use((req, res) => {
  res.status(404).json({ error: 'Not found' });
});

if (require.main === module) {
  app.listen(port, () => {
    console.log(`FYP app v${APP_VERSION} listening on port ${port}`);
  });
}

module.exports = app;





















































