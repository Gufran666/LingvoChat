const path = require('path');
console.log('Looking for:', path.resolve(__dirname, 'config/serviceAccountKey.json'));

const admin = require('firebase-admin');
const serviceAccount = require(path.resolve(__dirname, 'config/serviceAccountKey.json'));

// Initialize Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://lingvochat-c28cc.firebaseio.com"
});

const db = admin.firestore();

// Test Firestore Connection
db.collection('test').add({ test: 'connection' })
  .then(docRef => {
    console.log('Test document added with ID: ', docRef.id);
  })
  .catch(error => {
    console.error('Error adding document: ', error);
  });
