const admin = require('firebase-admin');
const serviceAccount = require('../config/teachtouch-20b98-firebase-adminsdk-ui70y-03d39f428d.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://TeachTouch.firebaseio.com"
});

const db = admin.firestore();


module.exports = { db };