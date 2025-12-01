const express = require('express');
const app = express();
const port = process.env.PORT || 8080;

app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    time: new Date().toISOString(),
  });
});
// chnange to status: 'broken' } to demonsrate broekn piepline

if (require.main === module) {
  app.listen(port, () => {
    console.log(`FYP app listening on port ${port}`);
  });
}

module.exports = app;



































