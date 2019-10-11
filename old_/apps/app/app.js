const express = require('express')
const app = express()
app.use(express.static('public'));

// my precious code
app.get('/', (req, res) => res.redirect("/1.gif"));

// health endpoint
app.get('/health', (req, res) => res.send('so far so good!'));

// server settings
app.listen(8080, () => console.log('app is listening on port 8080'))

