# 🌱 KrishiSource

**An Open-Source, Offline-First Live Agricultural Price Feed App for Nepali Farmers.**

> **Built and maintained by [Zariya Labs](https://github.com/Zariya-Labs)**

---

## 📌 The Problem
Agriculture employs over 66% of Nepal's workforce, yet smallholder farmers consistently face critical bottlenecks when looking for current wholesale market rates:
1. **Lack of reliable internet access** in rural areas to check daily market prices.
2. **Fragmented and slow data ingestion** from major hubs like the Kalimati Fruits and Vegetable Market.
3. **Connectivity limits** during local development, preventing developer testing on physical mobile devices.

## 🚀 The Solution: KrishiSource
KrishiSource is an open-source Flutter mobile application and centralized backend architecture designed to solve these exact problems. It is built to be fast, strictly offline-first, natively localized for the Nepali language, and dynamically configurable.

### Core Features
* **📉 Offline Market Caching:** Automatically scrapes, syncs, and locally caches daily wholesale prices from the Kalimati Market Development Board using a highly optimized on-device Isar NoSQL database.
* **⚙️ Dynamic API Configuration:** Configurable API Base URL settings inside the app, letting developers and users point the app to a local PC's IP address (for physical device testing over Wi-Fi) or any custom hosted backend server.
* **🇳🇵 Native Localization:** Built from the ground up with a Nepali UI/UX, prioritizing ease of use for rural demographics.

---

## 🛠️ Tech Stack & Architecture

**Mobile Client (Flutter)**
* **Framework:** Flutter (Dart)
* **State Management:** Riverpod
* **Local Storage:** Isar (for ultra-fast, offline-first NoSQL caching)
* **Configuration:** Shared Preferences (for dynamic API endpoints configuration)

**Backend Service (FastAPI)**
* **Language:** Python
* **Framework:** FastAPI / Uvicorn
* **Scraper:** BeautifulSoup4 (session-based scraper targeting the official Kalimati Market board)

---

## 📁 Repository Structure

We follow a clean, modular feature-first architecture:

```text
├── android/               # Android native configuration
├── backend/               # Python FastAPI backend server
│   ├── main.py            # API entry point & caching logic
│   ├── scraper.py         # Kalimati scraper module
│   └── requirements.txt   # Python dependencies
├── lib/
│   ├── core/              # Shared utilities, database, and network setup
│   │   ├── database/      # Isar database initialization & caching helpers
│   │   └── network/       # Configurable API client
│   └── features/          # Modular feature sets
│       └── market_prices/ # Kalimati price listing & offline caching UI
└── test/                  # Unit and integration tests
```

---

## 🚀 Getting Started

### 1. Run the Python Backend
Navigate to the `backend` directory and set up a virtual environment:
```bash
cd backend
python3 -m venv .venv
source .venv/bin/activate  # On Windows, use `.venv\Scripts\activate`

# Install required packages
pip install fastapi uvicorn requests beautifulsoup4

# Start the FastAPI server
python main.py
```
Verify the server is running by visiting: `http://localhost:8000/api/v1/prices/latest`

### 2. Configure the Flutter App on a Physical Device
1. Make sure your computer and phone are connected to the **same Wi-Fi network**.
2. Find your computer's local IP address (e.g., run `ip route get 1.1.1.1` on Linux, `ipconfig` on Windows, or `ifconfig` on macOS).
3. Open the app on your phone, tap the **Settings (gear) icon** in the top right, and set the **Base URL** to:
   ```text
   http://<YOUR_COMPUTER_IP>:8000
   ```
4. If you run into a `No route to host` error, check your computer's firewall and ensure port `8000` is allowed (e.g., run `sudo firewall-cmd --add-port=8000/tcp --permanent && sudo firewall-cmd --reload` on Fedora).

---

## 🤝 How to Contribute
We welcome contributions from developers, data scientists, and UI/UX designers! 

1. Fork the repository.
2. Clone your fork: `git clone https://github.com/your-username/KrishiSource.git`
3. Create a new branch: `git checkout -b feature/your-feature-name`
4. Commit your changes: `git commit -m "feat: added new offline sync logic"`
5. Push to the branch: `git push origin feature/your-feature-name`
6. Submit a Pull Request to the `main` branch.

Please ensure you run `flutter format .` and `flutter analyze` before submitting any PRs.

---

## 📜 License
This project is licensed under the MIT License - see the LICENSE file for details. Open data, open source, open agriculture.
