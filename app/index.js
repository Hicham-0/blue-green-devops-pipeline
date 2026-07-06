const express = require('express');
const path = require('path');
const { version } = require('./package.json');

const app = express();
const PORT = process.env.PORT || 3000;
const APP_VERSION = version;

// Sert les fichiers statiques depuis public/ 
app.use(express.static(path.join(__dirname, 'public')));

// Health check - utilisé par le Load Balancer / CodeDeploy
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'healthy' });
});

// Info - vérifie la version déployée
app.get('/info', (req, res) => {
  res.status(200).json({
    app: 'portfolio-app',
    version: APP_VERSION,
    environment: process.env.NODE_ENV || 'development'
  });
});


if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`App v${APP_VERSION} running on port ${PORT}`);
  });
}

module.exports = app;