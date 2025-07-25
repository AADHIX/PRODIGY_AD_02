#  To‑Do App in Flutter with Hive Storage 

**A clean, intuitive Flutter-powered to‑do list app for efficient task management**

---

## 🚀 Description

The **To‑Do App** is a cross‑platform mobile application built with Flutter. It empowers users to effortlessly manage tasks—adding, editing, deleting, and marking them complete—with a sleek, user‑friendly interface and local data persistence.

Built as part of the Prodigy Infotech internship curriculum, this application showcases proficiency in Flutter development, state management, and local storage.

---

## 🎯 Core Features

- **Create Tasks** – Easily add new tasks with title, description, and optional due date.  
- **Read & View** – Browse pending and completed tasks in an organized list view.  
- **Update Tasks** – Tap a task to edit its content or due date.  
- **Delete Tasks** – Swipe or long‑press to remove unwanted tasks.  
- **Mark as Completed** – Use checkboxes to mark tasks as done—completed tasks are visually distinguished.  
- **Local Persistence** – All tasks are stored locally using `sqflite` (Hive for Flutter), ensuring data survives across app restarts.

---

## 📱 Screenshots

<!-- Replace with real screenshots once available -->
![todo1](https://github.com/user-attachments/assets/d575e58e-04b6-40bf-aa94-fe63098339f7)
![todo2](https://github.com/user-attachments/assets/47cf8a20-013a-45ac-bd26-ee63a392c8c8)
![todo3](https://github.com/user-attachments/assets/57593da9-f08d-4d59-bba6-adeb96fc8736)
![todo4](https://github.com/user-attachments/assets/a2fe48c7-de5f-42f4-bc1f-f8bf8718d036)


---

## 🧰 Installation & Usage

**Prerequisites**  
- Flutter SDK installed (≥ 3.0)  
- A connected Android/iOS device or emulator

**Get started:**

1. Clone the repository:  
   
  ###  git clone https://github.com/AADHIX/PRODIGY_AD_02.git
   cd PRODIGY_AD_02
Install dependencies:


Copy
Edit
flutter pub get
Run the app:


Copy
Edit
flutter run

###🛠 Architecture & Tech Stack
Flutter & Dart – Core UI and logic implementation.

State Management – Using Provider for reactive data flow.

Local Database – sqflite for SQLite operations.

UI Components – Built with Flutter’s Material library for consistency.

---
## ⚙️ Project Structure
bash
Copy
Edit
lib/
├── main.dart           # App entry point
├── models/             # Task data model
├── providers/          # State management logic
├── screens/            # UI screens: List, Add/Edit
└── db/                 # SQLite helper & DB setup

---

## 🏗️ How It Works
On startup, the app initializes a local database.

Tasks are fetched and displayed in the list.

User actions (add, edit, delete, toggle) update both the UI and database.

Changes persist across sessions.

## 🧪 Testing
Unit Tests: Verify the Task model, provider logic, and DB helper.

Widget Tests: Ensure UI screens render and respond as expected.

(Add actual test commands if present in your project)

## 🤝 Contributing
Contributions are welcome! Follow these steps:

Fork the repository

Create a new branch 

Make your changes and commit

Submit a pull request with detailed description

## 🧾 License
This project is made for learning purpose  License. See LICENSE for details.

## 📬 Contact
### Have questions or suggestions? Feel free to reach out via: 
### Email – aadhiadarsh192001@gmail.com

### GitHub Issues – report bugs or request enhancements



### Happy coding! 😊
