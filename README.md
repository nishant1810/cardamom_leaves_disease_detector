# 🌿 Cardamom Leaf Disease Detection App

An AI-powered mobile application built with **Flutter** and **TensorFlow Lite** to detect diseases in **cardamom leaves**. The app uses a **multi-stage validation pipeline** to ensure reliable predictions and to **reject invalid or non-cardamom images**.

---
## 🚀 Features

* 📸 Capture leaf image using camera
* 🖼️ Upload leaf image from gallery
* 🤖 AI-based disease detection (Healthy / Blight / Phyllosticta)
* 🌫️ Blur detection for low-quality images
* 📊 Confidence score with visual indicator
* 🩺 Severity-based recommendations (Mild / Moderate / Severe)
* 🗂️ Scan history with filter, select-all, and delete options
* 🌐 Language toggle (English / Hindi)

---

## 📱 Screenshots

### 🏠 Home Screen
![Home Screen](assets/screenshots/home_screen.png)

### 📜 Scan History
![Scan History](assets/screenshots/scan_history.png)

### 🧪 Disease Detection Result
![Result Screen](assets/screenshots/result_screen.png)

### ❌ Invalid Image Rejection
![Invalid Image](assets/screenshots/invalid_image.png)

---

## 🛠️ Tech Stack

* **Flutter** (UI)
* **Dart** (Logic)
* **TensorFlow Lite** (ML inference)
* **MobileNet-based CNN models**
* **Path Provider** (local storage)

---

## 📂 Project Structure 

```
lib/
├── screens/
│   ├── camera_screen.dart
│   ├── home_screen.dart
│   ├── history_screen.dart
│   ├── image_preview_screen.dart
│   └── result_screen.dart
├── services/
│   ├── classifier.dart
│   └── scan_storage.dart
├── core/
|   ├── constanst/ 
│   ├     └── strings.dart
│   ├── models/
│   ├     └── scan_result.dart
│   └── utils/
│        ├── image_quality.dart
│        └── image_validatior.dart
├── widgets/
│   ├── confidence_bar.dart
│   └── loading_overlay.dart
└── main.dart
```

---

## ⚙️ How to Run

1. Clone the repository
2. Run `flutter pub get`
3. Connect an Android device or emulator
4. Run `flutter run`


## 📄 License

This project is for academic and demonstration purposes.
