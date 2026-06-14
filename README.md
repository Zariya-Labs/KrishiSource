# 🌱 KrishiSource

**An Open-Source, Offline-First Agricultural Platform for Nepali Smallholder Farmers.**

> **Built and maintained by [Zariya Labs](https://github.com/Zariya-Labs)**

---

## 📌 The Problem
Agriculture employs over 66% of Nepal's workforce, yet smallholder farmers consistently face critical bottlenecks:
1. **Lack of reliable internet access** in rural areas to check daily market prices.
2. **Crop diseases** going undiagnosed due to a lack of immediate, on-the-ground agricultural expertise.
3. **Fragmented data** from major hubs like the Kalimati Fruits and Vegetable Market.

## 🚀 The Solution: KrishiSource
KrishiSource is an open-source Flutter mobile application and centralized backend architecture designed to solve these exact problems. It is built to be fast, strictly offline-first, and natively localized for the Nepali language.

### Core MVP Features
* **📉 Offline Market Caching:** Automatically scrapes, syncs, and locally caches daily wholesale prices from the Kalimati Market Development Board using a highly optimized on-device NoSQL database.
* **📸 Edge AI Disease Diagnosis:** Integrates a localized TensorFlow Lite (TFLite) computer vision model directly into the app bundle. Farmers can scan crop leaves to diagnose diseases without needing an active internet connection.
* **🇳🇵 Native Localization:** Built from the ground up with Nepali UI/UX, prioritizing ease of use for rural demographics.

---

## 🛠️ Tech Stack & Architecture

This project is built using a clean, feature-first architecture to ensure maximum scalability and ease of open-source contribution.

**Mobile Client (Flutter)**
* **Framework:** Flutter (Dart)
* **State Management:** Riverpod / BLoC
* **Local Storage:** Isar (for ultra-fast, offline-first NoSQL caching)
* **Edge AI:** TensorFlow Lite (`tflite_flutter`)

**Backend & Data Aggregation**
* **API Server:** Node.js (TypeScript) / Python (FastAPI)
* **Data Sources:** Web scrapers targeting official Kalimati Market APIs and Open Government Data portals.

---

## 📁 Repository Structure

We follow a strict feature-first architecture. When contributing, please ensure your code aligns with this structure:

```text
lib/
│
├── core/                  # Shared utilities, routing, and themes
│   ├── database/          # Isar/Hive initialization & local repositories
│   ├── network/           # API client and interceptors
│   └── constants/         # App constants & localization strings
│
└── features/              # Modular, isolated feature sets
    ├── market_prices/     # Kalimati price listing & offline caching logic
    ├── crop_diagnosis/    # TFLite camera implementation & ML runner
    └── dashboard/         # Main user interface

🤝 How to Contribute
We welcome contributions from developers, data scientists, and UI/UX designers! Whether you are optimizing the Flutter architecture, training a better TFLite model for Nepali crops, or writing backend scrapers, your help is valued.

Fork the repository.

Clone your fork: git clone https://github.com/your-username/KrishiSource-app.git

Create a new branch: git checkout -b feature/your-feature-name

Commit your changes: git commit -m "feat: added new offline sync logic"

Push to the branch: git push origin feature/your-feature-name

Submit a Pull Request to the main branch of this repository.

Please ensure you run flutter format . and flutter analyze before submitting any PRs.

📜 License
This project is licensed under the MIT License - see the LICENSE file for details. Open data, open source, open agriculture.
