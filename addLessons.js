const admin = require('firebase-admin');

// Initialize Firebase Admin SDK using the service account key JSON file
const serviceAccount = require('./config/serviceAccountKey.json'); // Ensure this path is correct

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://lingvochat-c28cc.firebaseio.com" // Ensure this URL is correct
});

const db = admin.firestore();

// Array of lessons to add
const lessons = [
  {
    id: '1',
    title: 'Introduction to French',
    content: [{ type: 'text', data: 'This lesson covers basic greetings and common phrases in French.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "How do you say 'Hello' in French?",
        options: ['Bonjour', 'Hola', 'Hello', 'Ciao'],
        correctAnswer: 'Bonjour'
      }
    ]
  },
  {
    id: '2',
    title: 'Basic Spanish Vocabulary',
    content: [{ type: 'text', data: 'Learn the basic vocabulary words in Spanish.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "How do you say 'Apple' in Spanish?",
        options: ['Manzana', 'Banana', 'Pomme', 'Mela'],
        correctAnswer: 'Manzana'
      }
    ]
  },
  {
    id: '3',
    title: 'German Pronouns',
    content: [{ type: 'text', data: 'Learn about the different pronouns in German.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the German word for 'You' (informal)?",
        options: ['Du', 'Sie', 'Ihr', 'Er'],
        correctAnswer: 'Du'
      }
    ]
  },
  {
    id: '4',
    title: 'Japanese Hiragana',
    content: [{ type: 'text', data: 'Learn the basic Hiragana characters in Japanese.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the Hiragana character for 'A'?",
        options: ['あ', 'い', 'う', 'え'],
        correctAnswer: 'あ'
      }
    ]
  },
  {
    id: '5',
    title: 'Italian Greetings',
    content: [{ type: 'text', data: 'Learn how to greet people in Italian.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "How do you say 'Good morning' in Italian?",
        options: ['Buongiorno', 'Buona sera', 'Ciao', 'Salve'],
        correctAnswer: 'Buongiorno'
      }
    ]
  },
  {
    id: '6',
    title: 'Mandarin Numbers',
    content: [{ type: 'text', data: 'Learn how to count from 1 to 10 in Mandarin.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the Mandarin word for 'One'?",
        options: ['Yi', 'Er', 'San', 'Si'],
        correctAnswer: 'Yi'
      }
    ]
  },
  {
    id: '7',
    title: 'Portuguese Colors',
    content: [{ type: 'text', data: 'Learn the names of different colors in Portuguese.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "How do you say 'Red' in Portuguese?",
        options: ['Vermelho', 'Azul', 'Amarelo', 'Verde'],
        correctAnswer: 'Vermelho'
      }
    ]
  },
  {
    id: '8',
    title: 'Korean Alphabet',
    content: [{ type: 'text', data: 'Learn the basic Hangul characters in Korean.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the Hangul character for 'G'?",
        options: ['ㄱ', 'ㄴ', 'ㄷ', 'ㄹ'],
        correctAnswer: 'ㄱ'
      }
    ]
  },
  {
    id: '9',
    title: 'Arabic Numbers',
    content: [{ type: 'text', data: 'Learn how to count from 1 to 10 in Arabic.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the Arabic word for 'Five'?",
        options: ['خمسة', 'أربعة', 'ستة', 'سبعة'],
        correctAnswer: 'خمسة'
      }
    ]
  },
  {
    id: '10',
    title: 'Swedish Days of the Week',
    content: [{ type: 'text', data: 'Learn the names of the days of the week in Swedish.' }],
    isCompleted: false,
    quizQuestions: [
      {
        question: "What is the Swedish word for 'Monday'?",
        options: ['Måndag', 'Tisdag', 'Onsdag', 'Torsdag'],
        correctAnswer: 'Måndag'
      }
    ]
  }
];

// Add lessons to Firestore
lessons.forEach(async (lesson) => {
  await db.collection('lessons').doc(lesson.id).set(lesson);
  console.log(`Added lesson with id: ${lesson.id}`);
});
