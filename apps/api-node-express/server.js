const express = require('express');
const app = express();
app.get('/healthz', (_, res) => res.json({ status: 'ok' }));
app.get('/', (_, res) => res.json({ msg: 'Hello from secure Node API' }));
app.listen(8080, '0.0.0.0');
