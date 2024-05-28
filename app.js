// app.js

const express = require('express');
const app = express();
const port = 3000;
const path = require('path');

// Middleware to parse incoming requests with JSON payloads
app.use(express.json());

// Middleware to parse incoming requests with URL-encoded payloads
app.use(express.urlencoded({ extended: true }));

// Serve static files from the 'public' directory
app.use(express.static(path.join(__dirname, 'public')));

// Route to serve index.html
app.get('/index', (req, res) => {
  res.sendFile(path.join(__dirname, 'public', 'index.html'));
});

// Routes
const usersRouter = require('./users');
app.use('/', usersRouter); // Use the usersRouter for all routes

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
