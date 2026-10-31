# AetherStudio Elite 🎨✨

[![Android CI/CD](https://github.com/ma0780542/AetherStudio/actions/workflows/android-build-release.yml/badge.svg)](https://github.com/ma0780542/AetherStudio/actions/workflows/android-build-release.yml)
[![Kotlin](https://img.shields.io/badge/Kotlin-2.0.21-purple.svg)](https://kotlinlang.org)
[![Java](https://img.shields.io/badge/Java-17-orange.svg)](https://www.oracle.com/java/)
[![Jetpack Compose](https://img.shields.io/badge/Jetpack%20Compose-BOM%202024.10.01-blue.svg)](https://developer.android.com/jetpack/compose)
[![Min SDK](https://img.shields.io/badge/Min%20SDK-28%20(Android%209.0)-green.svg)](https://developer.android.com/about/dashboards)
[![Target SDK](https://img.shields.io/badge/Target%20SDK-36%20(Android%2016)-brightgreen.svg)](https://developer.android.com)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)

**AetherStudio Elite** is a next-generation professional digital painting, illustration, and vector design studio for Android. Built with a high-performance **Kotlin & Java hybrid architecture**, it bridges an edge-to-edge Jetpack Compose surface with an accelerated multi-layer creative canvas, delivering authentic Adobe Illustrator desktop controls on large screens and a distraction-free minimalist canvas on phones and tablets.

---

## 🚀 Key Highlights & Capabilities

### 1. Dual-Mode Adaptive Workspace
- **Phones & Tablets (< 900px)**: Minimalist, distraction-free edge-to-edge drawing canvas with a floating pill header, docked thumb controls, and a slide-up gesture-driven layer sheet.
- **Desktop & Foldables (≥ 900px)**: Authentic **Adobe Illustrator Pro** interface featuring an interactive application menu bar (`File`, `Edit`, `Object`, `Type`, `Select`, `Effect`, `View`, `Window`), live control property strip, dual-column tool palette, and dockable panels.

### 2. Multi-Layer Creative Engine (Ibis Paint Grade)
- **Lineart Smart Containment**: Inside/outside outline protection allowing artists to color lineart without bleeding across ink contours.
- **Catmull-Rom Exponential Stabilization**: 0 to 10 smoothing curve levels providing silky, jitter-free lineart on touchscreens and styluses.
- **12 Real-Time Blending Modes**: Normal, Multiply, Screen, Overlay, Darken, Lighten, Color Dodge, Color Burn, Hard Light, Soft Light, Difference, and Exclusion.
- **Hover & Scrub Blend Preview**: Hovering over the blend badge on any active layer temporarily cycles through all 12 blend modes with real-time canvas preview without mutating saved state.

### 3. Professional Multi-Format Publishing
- **📐 SVG (Scalable Vector Graphics)**: Serializes XML vector paths, layer groups, opacities, and CSS blend modes.
- **🎨 PSD (Adobe Photoshop Document)**: Generates spec-compliant binary `8BPS` multi-layer files with 300 DPI resolution records, per-layer bounding boxes, 4 RGBA channel byte streams, and Photoshop blend keys (`norm`, `mul `, `scrn`, `over`, etc.).
- **🖨️ TIFF (300 DPI High-Resolution Print)**: Encodes spec-compliant Little-Endian (`II*`) TIFF files with 15 standard IFD tags and uncompressed RGBA pixel buffers.
- **🖼️ Standard Formats**: Lossless PNG and high-quality JPEG with Android `MediaStore` gallery integration and native system share intents (`ACTION_SEND`).

### 4. Gemini AI Artistic Vision Coach
- Built-in Gemini AI vision diagnostics analyzing canvas color harmony, composition balance, stroke rhythm, and recommended blend modes for active layer groups.

---

## 🏛️ System Architecture

The application adopts a clean separation of concerns leveraging Android modern best practices:

```
┌────────────────────────────────────────────────────────────────────────┐
│                        Jetpack Compose UI Layer                        │
│                           (com.example.ui)                             │
├────────────────────────────────────────────────────────────────────────┤
│  • Edge-to-Edge display with dynamic WindowInsets                      │
│  • Material 3 ColorScheme & typography                                 │
│  • Hardware back-press interceptor callback                            │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                    Kotlin Lifecycle & Bridge Layer                     │
│                        (MainActivity & Bridge)                         │
├────────────────────────────────────────────────────────────────────────┤
│  • AetherApplication.kt: Multi-process isolation & cache pre-creation  │
│  • MainActivity.kt: WebSettings hardware acceleration & DOM storage   │
│  • PublishingBridge.kt: Coroutine background I/O & JavascriptInterface│
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   Java Native Publication Subsystem                    │
│                    (CanvasPublishHelper.java)                          │
├────────────────────────────────────────────────────────────────────────┤
│  • Base64 streaming decoding without OOM heap bottlenecks             │
│  • Scoped Storage routing (MediaStore.Images & MediaStore.Downloads)   │
│  • Android 10+ (API 29+) QScopedStorage with app storage fallbacks    │
│  • FileProvider content URI marshaling & ACTION_SEND system intents    │
└───────────────────────────────────┬────────────────────────────────────┘
                                    │
                                    ▼
┌────────────────────────────────────────────────────────────────────────┐
│                   Creative Canvas Webview Core Engine                  │
│                     (app/src/main/assets/index.html)                   │
├────────────────────────────────────────────────────────────────────────┤
│  • Catmull-Rom stroke interpolation & pressure curve modeling          │
│  • Dynamic multi-canvas layer stack (mix-blend-mode composition)       │
│  • SVG XML serializer & Photoshop 8BPS / TIFF binary packet encoders   │
└────────────────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tech Stack & Dependencies

- **Language**: Kotlin 2.0.21 & Java 17
- **UI Toolkit**: Jetpack Compose (BOM 2024.10.01) with Material Design 3
- **Build System**: Gradle 9.3.1 with Kotlin DSL (`build.gradle.kts`)
- **Testing**: Robolectric JVM unit testing framework (`:app:testDebugUnitTest`)
- **Android Target**: Min SDK 28 (Android 9.0 Pie) • Target SDK 36 (Android 16)
- **CI/CD**: GitHub Actions runner on `ubuntu-latest` with automated APK artifact staging

---

## 💻 Local Building & Development

### Prerequisites
- [Android Studio Iguana, Koala, Ladybug](https://developer.android.com/studio) or newer
- JDK 17 (Eclipse Temurin, Azul Zulu, or OpenJDK)
- Android SDK Platform 34/35/36 with Build-Tools installed

### Clone the Repository
```bash
git clone https://github.com/ma0780542/AetherStudio.git
cd AetherStudio
```

### Build Debug APK
Using the included Gradle wrapper:

```bash
# On Linux / macOS:
chmod +x gradlew
./gradlew assembleDebug

# On Windows:
gradlew.bat assembleDebug
```
The compiled debug APK will be generated at:
`app/build/outputs/apk/debug/app-debug.apk`

### Run Unit Tests
To run the automated JVM and Robolectric test suite locally:
```bash
./gradlew testDebugUnitTest --continue
```
HTML test reports will be generated at:
`app/build/reports/tests/testDebugUnitTest/index.html`

### Install on Connected Device / Emulator
```bash
./gradlew installDebug
```

---

## 🤖 GitHub Actions CI/CD Pipeline (Android • iOS • Windows)

The repository includes a bulletproof multi-platform GitHub Actions workflow located in [`.github/workflows/android-build-release.yml`](.github/workflows/android-build-release.yml).

### ⚙️ Crucial GitHub Setting (Prevents Release Publishing Errors):
If your GitHub Action failed previously with permission errors, make sure this one setting is enabled on GitHub:
1. Go to your repository on GitHub.
2. Click **Settings** (tab on top right).
3. In the left sidebar, click **Actions** ➔ **General**.
4. Scroll down to **Workflow permissions**.
5. Select **"Read and write permissions"** and check **"Allow GitHub Actions to create and approve pull requests"**.
6. Click **Save**.

---

### 🚀 2 Ways to Publish From the GitHub "Actions" Tab:

#### Option 1: One-Click Manual Trigger (From Browser)
1. Go to your GitHub repository and click the **Actions** tab.
2. In the left list, click **"Multi-Platform CI/CD & Release Pipeline (Android, iOS, Windows)"**.
3. Click the **"Run workflow"** dropdown button on the right.
4. Select `main` branch, keep options enabled, and click the green **"Run workflow"** button!
5. When complete, download the APKs or Web PWA zip directly from the **Artifacts summary** at the bottom of the run, or check your repository's **Releases** page!

#### Option 2: Automated Tag Release
```bash
./scripts/publish_release.sh -p
```
or manually:
```bash
git tag v1.0.1
git push origin v1.0.1
```

---

### 📦 Downloadable Assets Produced:
- **`AetherStudio-Elite-Android-Universal-debug.apk`**: Pre-signed APK ready to sideload immediately onto any Android device (Android 7.0+ / API 24+).
- **`AetherStudio-Elite-Android-release.apk`**: Production release APK.
- **`AetherStudio-Elite-Web-PWA-iOS-Windows.zip`**: Complete offline standalone package:
  - **iOS (iPhone/iPad)**: Host on GitHub Pages or Safari ➔ tap *Share* ➔ *Add to Home Screen*.
  - **Windows 10/11**: Double-click `run-windows.bat` or open in Edge/Chrome and click *Install App* in the address bar.
  - **macOS / Linux**: Double-click or run `./run-macos-linux.sh`.
- **`checksums.sha256`**: Cryptographic verification checksums.

---

### 🔒 Zero Firebase Account Requirement:
- You do **NOT** need a Firebase account, Google Cloud billing, or API credentials to use or publish this app.
- All layers, undo/redo history, brush stabilization, HSB color wheel, Photoshop filters, vector Bezier tools, and multi-format exports (PNG, JPG, SVG, PSD, TIFF) run 100% locally and offline.

---

## 📁 Repository Structure

```
AetherStudio/
├── .github/
│   └── workflows/
│       └── android-build-release.yml     # Complete GitHub Actions CI/CD
├── app/
│   ├── src/
│   │   ├── main/
│   │   │   ├── assets/
│   │   │   │   └── index.html            # Accelerated Creative Core & Illustrator UI
│   │   │   ├── java/com/example/
│   │   │   │   ├── AetherApplication.kt  # Process isolation & cache pre-creation
│   │   │   │   ├── MainActivity.kt       # Jetpack Compose Edge-to-Edge Activity
│   │   │   │   └── publish/
│   │   │   │       ├── CanvasPublishHelper.java # Scoped storage & binary encoding
│   │   │   │       └── PublishingBridge.kt      # Coroutine JavascriptInterface
│   │   │   └── res/                      # Android resources, strings, & drawables
│   │   └── test/java/com/example/
│   │       └── ExampleRobolectricTest.kt # JVM test suite
│   └── build.gradle.kts                  # App Gradle configuration
├── gradle/
│   ├── libs.versions.toml                # Centralized Version Catalog
│   └── wrapper/
│       └── gradle-wrapper.properties     # Gradle 9.3.1 distribution
├── gradlew                               # Unix Gradle wrapper launcher
├── gradlew.bat                           # Windows Gradle wrapper launcher
├── LICENSE                               # Apache 2.0 Open Source License
└── README.md                             # Documentation & guides
```

---

## 📄 License

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0).
