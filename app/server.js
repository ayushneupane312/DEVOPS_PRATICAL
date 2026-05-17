const http = require('http');
const PORT = process.env.PORT || 3000;
const server = http.createServer((req, res) => {
  if (req.url === '/health') {
    res.writeHead(200);
    res.end(JSON.stringify({ status: 'ok', timestamp: new Date() }));
  } else {
    res.writeHead(200);
    res.end('Hello from DevOps App!');
  }
});
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
