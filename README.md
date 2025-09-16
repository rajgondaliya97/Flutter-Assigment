# Streak Tracker - Full Stack Application  

A complete streak tracking application built with **Flutter (Frontend)** and **Node.js (Backend)**. Track daily check-ins, maintain streaks, calculate success rates, and visualize progress with an interactive calendar.  

---

## 🚀 Project Overview  

This project demonstrates a **full-stack streak tracking app** where users can:  
- ✅ Check in daily to maintain their streak  
- ✅ View streak statistics (current, longest, total check-ins)  
- ✅ See progress on an interactive calendar  
- ✅ Track missed vs. completed days through history  
- ✅ Calculate streak success rate (%)  

---

## 📁 Project Structure  

```
streak_project/
├── streak_backend/        # Node.js Express API
│   ├── app.js            # Main server file
│   ├── package.json      # Dependencies and scripts
│   └── README.md         # Backend documentation
├── streak_frontend/       # Flutter application (upsquaretask)
│   ├── lib/              # Flutter source code
│   ├── pubspec.yaml      # Flutter dependencies
│   └── README.md         # Frontend documentation
└── README.md              # This file
```

---

## 🛠️ Technology Stack  

### Backend  
- **Node.js** – Runtime environment  
- **Express.js** – Web framework  
- **CORS** – Cross-origin resource sharing  
- **In-memory storage** – No database required  

### Frontend  
- **Flutter** – Cross-platform UI framework  
- **Dart** – Programming language  
- **Provider** – State management  
- **HTTP** – API communication  
- **Table Calendar** – Calendar widget  
- **Intl** – Date formatting & localization  

---

## ⚡ Quick Start  

### 1. Start the Backend Server  

```bash
cd streak_backend
npm install
npm run dev   # or npm start
```

The server runs on:  
👉 `http://localhost:3000`  

### 2. Run the Flutter App  

```bash
cd streak_frontend
flutter pub get
flutter run
```

---

## 🎯 Features  

### Backend API  
- **POST /check-in** → Log daily check-in  
- **GET /streak** → Get current streak info  
- **GET /history** → Returns both check-in and missed days  

### Frontend App  
- **Streak Display** → Current, longest, total check-ins  
- **Daily Check-in Button** → One-click check-in (with duplicate prevention)  
- **Calendar View** → Interactive calendar showing check-ins & missed days  
- **Success Rate** → % of successful check-ins  
- **UI Widgets** → Modular components (cards, buttons, stats)  

---

## 📊 Streak Logic  

1. First check-in starts streak (1 day).  
2. Consecutive check-ins increment streak.  
3. Missing a day resets current streak.  
4. Only one check-in allowed per day.  
5. Longest streak & total check-ins are auto-tracked.  
6. Calendar shows check-in vs. missed days.  

---

## 🌐 API Documentation  

### Endpoints  

| Method | Endpoint     | Description                          |
|--------|-------------|--------------------------------------|
| POST   | `/check-in` | Log today’s check-in                 |
| GET    | `/streak`   | Get streak stats (current, longest, total) |
| GET    | `/history`  | Get both check-in and missed days    |

### Example Responses  

**✅ GET /streak**  
```json
{
  "currentStreak": 3,
  "longestStreak": 5,
  "totalCheckIns": 12,
  "lastCheckIn": "2025-09-16"
}
```

**✅ POST /check-in**  
```json
{
  "success": true,
  "message": "Check-in successful 🎉",
  "currentStreak": 4,
  "longestStreak": 5,
  "totalCheckIns": 13,
  "lastCheckIn": "2025-09-17"
}
```

**✅ GET /history**  
```json
{
  "checkInDays": ["2025-09-16", "2025-09-17"],
  "missedDays": ["2025-09-15", "2025-09-14"]
}
```

---

## 📱 Supported Platforms  

The Flutter app supports:  
- ✅ Android  
- ✅ iOS  
- ✅ Web  
- ✅ Windows / macOS / Linux  

---

## 🎨 UI/UX Highlights  

- Modern **Material Design**  
- Smooth animations & transitions  
- Responsive layouts  
- Calendar heatmap  
- Light & dark themes  

---

## 👨‍💻 Author  

**Raj Gondaliya**  
📧 Email: rajgondaliya972003@gmail.com  
📞 Contact: +91 6353751734  

---

**Built with ❤️ using Flutter + Node.js**  
