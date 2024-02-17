const jwt = require('jsonwebtoken');

const verifyToken = (req, res, next) => {
  const token = req.headers.authorization?.split(' ')[1]; // Assuming token is sent in the 'Authorization' header
  if (!token) {
    return res.status(401).send('Unauthorized');
  }

  jwt.verify(token, 'your_secret_key', (err, decoded) => {
    if (err) {
      return res.status(401).send('Unauthorized');
    }
    req.user_id = decoded.user_id; // Store user ID in request for future use
    next();
  });
};

module.exports = verifyToken;
