This repository contains two parts:

Node.js Backend (task-node-js) – REST API built with Express.js.

Flutter App (upsquaretask) – Cross-platform mobile app built with Flutter.

🚀 Node.js Backend
📂 Project Structure
task-node-js/
│── app.js        # Main entry point
│── package.json  # Node.js dependencies & scripts
│── routes/       # API routes
│── models/       # Data models (if any)

🔧 Installation
# Navigate to backend folder
cd task-node-js

# Install dependencies
npm install

▶️ Run Project
# Run normally
npm start

# Run with nodemon (development)
npm run dev

📦 Dependencies

express ^5.1.0

body-parser ^2.2.0

nodemon (dev) ^3.1.10

📱 Flutter App 

📂 Project Structure
lib/
│── main.dart                # Entry point
│
├── model/                   # Data models
│   ├── calendar_data.dart
│   └── streak_model.dart
│
├── services/                # API & services
│   └── api_service.dart
│
├── src/                     # Constants & configurations
│   ├── app_constants.dart
│   └── app_urls.dart
│
├── view_models/             # Business logic (MVVM)
│   ├── calendar_view_model.dart
│   └── streak_view_model.dart
│
├── views/                   # UI screens
│   ├── calendar_view.dart
│   └── home_screen.dart
│
└── widgets/                 # Reusable UI components
    ├── check_in_button.dart
    ├── legend_item.dart
    ├── remainder_card.dart
    ├── stat_card.dart
    └── stat_item.dart

🏗 Architecture

The Flutter app follows MVVM (Model-View-ViewModel) pattern:

Models → Define data structures.

ViewModels → Manage business logic & state (Provider).

Views → Screens that display UI.

Widgets → Reusable components.

Services → API integration.

▶️ Running the Flutter App
cd streak_frontend
flutter pub get
flutter run

📌 Features

✅ Node.js Backend with Express APIs
✅ Flutter Mobile App with MVVM architecture
✅ Streak tracking with check-in & history
✅ Calendar integration with missed & completed days
✅ Clean and modular file structure
