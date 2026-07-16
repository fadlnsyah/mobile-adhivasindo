# Mobile Adhivasindo

## Project Overview

Mobile client untuk Take Home Test Fullstack Adhivasindo. Project ini disiapkan sebagai aplikasi Flutter yang akan menggunakan Backend Laravel Adhivasindo pada sprint berikutnya.

Sprint M-0 hanya berisi fondasi project, routing placeholder, theme, struktur folder, dan konfigurasi networking dasar.

## Tech Stack

- Flutter Stable
- Dart
- Riverpod
- Dio
- GoRouter
- SharedPreferences
- flutter_screenutil
- google_fonts
- equatable

## Installation

```bash
flutter pub get
```

## Run Project

Pastikan Android emulator berjalan, lalu jalankan:

```bash
flutter run
```

Backend lokal Laravel untuk Android emulator menggunakan base URL:

```text
http://10.0.2.2:8000/api
```

## Folder Structure

```text
lib/
├── core/
│   ├── constants/
│   ├── network/
│   ├── router/
│   ├── storage/
│   └── theme/
├── features/
│   ├── auth/
│   ├── dashboard/
│   └── content/
├── models/
├── services/
├── shared/
│   └── widgets/
└── utils/
```

## Validation

```bash
dart format .
flutter analyze
flutter test
```

## Author

Fadlan Syah
