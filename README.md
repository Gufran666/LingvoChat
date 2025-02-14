# LingvoChat - Language Learning App

[![Flutter](https://img.shields.io/badge/Flutter-3.13-blue?logo=flutter)](https://flutter.dev) [![Firebase](https://img.shields.io/badge/Firebase-9.22-orange?logo=firebase)](https://firebase.google.com) [![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT) [![Demo Video](https://img.shields.io/badge/Watch-Demo-red)](https://example.com/demo-video)

## Demo Video
  - https://youtu.be/cu3Dd7Wdp5w

## Table of Contents
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Installation](#installation)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Code Highlights](#code-highlights)
- [Screenshots](#screenshots)
- [Development Timeline](#development-timeline)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)

## ✨ Features

### Core Functionality
- 🔐 **Secure Authentication** with Firebase (Email/Google)
- 🌐 **Real-time Translation** for 100+ languages
- 🤖 **AI Conversation Practice** with grammar feedback
- 📚 **Interactive Lessons** with spaced repetition
- 📱 **Offline-First Design** using Hive database
- 🏆 **Gamification System** with streaks & achievements

### Additional Features
- Multiple screens with detailed software architecture and structure
- Good UI design
- Lessons fetched from Firebase
- Translation system using an API key (mock translation for portfolio project)
- Voice translation
- Multiple language lessons
- Quiz screen with general knowledge and language quizzes
- Chat section with AI regarding lessons and language learning (mock chat for portfolio project)
- Eye-catching homescreen with profile section (help screen, notification settings, language preferences, etc.)
- Achievements section
- Splash screen for good user experience

## 🛠 Tech Stack

### Frontend
| Technology | Purpose | 
|------------|---------|
| Flutter | Cross-platform framework |
| Dart | Programming language | 
| Riverpod | State management |
| Hive | Local database |
| Lottie | Animations |

### Backend
| Technology | Purpose |
|------------|---------|
| Firebase Auth | User authentication |
| Firestore | Cloud database |
| Cloud Functions | Serverless logic |

### AI/NLP
| Technology | Purpose |
|------------|---------|
| LanguageTool | Grammar checking |
| MockGPT | Conversation responses |
| Speech_to_Text | Voice input |

## 🚀 Installation

1. **Clone Repository**
   ```bash
   git clone https://github.com/Gufran666/LingvoChat
   cd lingvoChat

2. **Navigate to the project directory**:
   cd language_app
3. **Install dependencies**:
   flutter pub get

## ⚙️ Configuration 
1. Set up Firebase:
   - Create a Firebase project and configure the necessary services (Authentication, Firestore, etc.).

   - Download the google-services.json file for Android and place it in the android/app directory.

   - Download the GoogleService-Info.plist file for iOS and place it in the ios/Runner directory.

2. Add your API key for the translation system:
   - Replace YOUR_API_KEY in the lib/translation directory with your actual API key.

## 🗂 Project Structure
   - lib/: Contains main dart code 
   - core/: Contains app themes, fonts, constants, utilities, services and routers.
   - features/: Contains auth system, home,splash,welcome screen of the app.
   - learning/: Contains lessons/quiz screen and the logic files for quiz and lesson data fetching.
   - translation/: Contains translation screen, translation logic, mock translation logic, language preferences.
   - widgets/: Contains custom widgets used in the app.
   - main.dart/: Contains main runApp logic , logic for the whole app , main entry point of the app.
   - config/: Contains configuration files.
   - assets/: Contains images used in the app.
   - android/: Contains android specific files.
   - ios/: Ios specific files.

## 🌟 Code Highlights
   - Detailed software architecture and structure

   - Efficient state management using Riverpod

   - Integration with Firebase for authentication and database

   - Implementation of mock translation and chat features for demonstration purposes

   - Responsive and attractive UI design

## 📸 Screenshots
   - Screenshots of the app are stored in the screenshots directory. 

## 📅 Development Timeline 
   - This app took almost 5 weeks to complete, this is my first portfolio project, This is a "Learning by doing" project.

## 🤝 Contributing
   - Fork the repository

   - Create a new branch (git checkout -b feature/YourFeature)

   - Commit your changes (git commit -m 'Add some feature')

   - Push to the branch (git push origin feature/YourFeature)

   - Open a pull request

## 📜 License
   - This project is licensed under the MIT License. See the LICENSE file for details.


## 📬 Contact

For any inquiries, please contact gufranbiz666@gmail.com or visit my github profile @gufran666.