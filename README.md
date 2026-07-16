# Mobile Adhivasindo

## Project Overview

Mobile Adhivasindo adalah aplikasi Flutter untuk Take Home Test Fullstack Adhivasindo. Aplikasi ini menggunakan backend Laravel yang sudah tersedia untuk autentikasi JWT dan pengelolaan content.

## Features

- Login menggunakan backend Laravel.
- Penyimpanan JWT dan user dengan SharedPreferences.
- Dashboard mobile dengan gaya LMS.
- Content list dari backend.
- Search content menggunakan backend.
- Pagination dengan Load More.
- Pull to refresh.
- Content detail.
- Create content.
- Edit content.
- Delete content dengan dialog konfirmasi.

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

## Run

Pastikan backend Laravel berjalan terlebih dahulu:

```bash
php artisan serve
```

Jalankan aplikasi mobile:

```bash
flutter run
```

## Backend URL

Base URL backend dikonfigurasi pada:

```text
lib/core/constants/api_constants.dart
```

Default untuk Android emulator:

```text
http://10.0.2.2:8000/api
```

## Folder Structure

```text
lib/
|-- core/
|   |-- constants/
|   |-- network/
|   |-- router/
|   |-- storage/
|   `-- theme/
|-- features/
|   |-- auth/
|   |-- dashboard/
|   `-- content/
|-- models/
|-- services/
|-- shared/
|   `-- widgets/
`-- utils/
```

## Validation

```bash
dart format .
flutter analyze
flutter test
```

## Author

Fadlan Syah
