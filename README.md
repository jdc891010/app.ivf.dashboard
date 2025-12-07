# IVF Clinic Dashboard

A Flutter web application for IVF clinics to manage patients, appointments, treatments, lab results, and more.

## Tech Stack
- Flutter (`>=3.0.0`) and Dart
- State management: `provider`
- HTTP client: `http`
- UI and visuals: `google_fonts`, `fl_chart`, `data_table_2`, `table_calendar`, `flutter_svg`
- Storage: `shared_preferences`

## Repository Layout
```
app.ivf.dashboard/
├─ app/
│  ├─ lib/
│  │  ├─ main.dart
│  │  └─ screens/
│  │     ├─ dashboard_screen.dart
│  │     ├─ patients_screen.dart
│  │     ├─ patient_detail_screen.dart
│  │     ├─ appointments_screen.dart
│  │     ├─ appointment_form_screen.dart
│  │     ├─ treatments_screen.dart
│  │     ├─ protocols_screen.dart
│  │     ├─ protocol_detail_screen.dart
│  │     ├─ lab_results_screen.dart
│  │     ├─ messenger_screen.dart
│  │     ├─ medical_notes_screen.dart
│  │     ├─ staff_screen.dart
│  │     └─ settings_screen.dart
│  ├─ assets/images/
│  │  ├─ logo.svg
│  │  └─ sarah_profile.jpg
│  ├─ pubspec.yaml
│  └─ index.html
├─ .gitignore
└─ README.md
```

## Application Entry
- Entry point: `app/lib/main.dart`
- Initial route: `/dashboard` (`app/lib/main.dart:81`)
- Named routes registered in `MaterialApp.routes` (`app/lib/main.dart:82-97`)

## Prerequisites
- Install Flutter SDK (3.x) and enable web support: `flutter config --enable-web`
- Ensure Chrome is installed for web runs

## Setup
- `cd app`
- `flutter pub get`

## Run (Web)
- `flutter run -d chrome`

## Build (Web)
- `flutter build web`
- Output in `app/build/web`

## Test
- `flutter test`

## Lint / Analyze
- `flutter analyze`

## Notable Dependencies
- Declared in `app/pubspec.yaml` (`app/pubspec.yaml:11-24`)

## Assets
- Configured under `flutter.assets` (`app/pubspec.yaml:30-33`)
- Images located in `app/assets/images/`
