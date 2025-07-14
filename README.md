# 📱 TodoMaster - Flutter Todo App with Hive & State Management

![App Banner](screenshots/banner.png) *(Optional promotional image)*

## 🌟 Overview
TodoMaster is a high-performance todo application built with Flutter that features:
- **Hive Database** for blazing-fast local storage
- **State Management** (Provider/Riverpod/Bloc - choose one)
- Clean Material 3 design with dark/light theme
- Offline-first architecture

## 🏗️ Architecture
```mermaid
graph TD
    A[UI Layer] -->|Notifies| B[State Management]
    B -->|Reads/Writes| C[Hive Database]
    C -->|Persists| D[Local Device Storage]


## 📂 Project Structure
lib/
├── 📁 data/
│   ├── models/              # Data models (TodoModel)
│   ├── repositories/        # Hive operations
│   └── datasources/         # Local storage adapters
├── 📁 domain/
│   ├── entities/            # Business objects
│   └── repositories/        # Abstract interfaces
├── 📁 presentation/
│   ├── screens/             # All UI pages
│   ├── widgets/             # Reusable components
│   └── providers/          # State management
├── 📁 core/
│   ├── constants/           # App constants
│   └── utils/               # Helper functions
└── main.dart               # App entry point
