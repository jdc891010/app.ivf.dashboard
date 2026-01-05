# IVF Clinic Dashboard

A comprehensive digital ecosystem designed to streamline fertility treatment management, enhancing clinical efficiency and patient care through centralized data and real-time communication.

## Overview
The IVF Clinic Dashboard unifies the complex workflows of fertility treatments—from patient intake and protocol planning to lab result tracking and cycle monitoring—into a single, intuitive interface. It supports fertility specialists, embryologists, and nursing staff in making data-driven decisions while offering a transparent experience for patients.

For more detailed information, please refer to [OVERVIEW.md](OVERVIEW.md).

## Key Features
- **Executive Dashboard**: Real-time metrics on success rates, active patients, and daily appointments.
- **Protocol Management**: Create and track custom treatment protocols (e.g., Long Protocol with Antagonist).
- **Lab Results**: Integrated tracking for hormone panels, semen analysis, and genetic tests.
- **Patient Tracking**: Comprehensive profiles with medical history and treatment cycles.
- **Secure Messenger**: Direct communication between clinic staff and patients.
- **Staff Management**: Tools for managing roles and shifts.
- **Appointment Scheduling**: Integrated calendar for consultations and procedures.

## Tech Stack
- **Framework**: Flutter (`>=3.0.0`) & Dart
- **State Management**: `provider` (or local state where appropriate)
- **Visuals**: `fl_chart`, `google_fonts`, `flutter_svg`
- **Data Display**: `data_table_2`, `table_calendar`
- **Testing**: `flutter_test`, `integration_test`

## Repository Structure
```
app.ivf.dashboard/
├── app/
│   ├── integration_test/   # End-to-end tests
│   ├── lib/
│   │   ├── screens/        # UI Screens (Dashboard, Patients, etc.)
│   │   ├── widgets/        # Reusable components
│   │   ├── utils/          # Helpers and validators
│   │   └── main.dart       # Entry point
│   ├── test/               # Unit and Widget tests
│   ├── assets/             # Images and static resources
│   ├── Makefile            # Automation for testing
│   ├── test.bat            # Windows batch script for testing
│   └── pubspec.yaml        # Dependencies
├── screen_samples/         # Screenshots of the application
├── OVERVIEW.md             # Detailed product documentation
└── README.md               # This file
```

## Getting Started

### Prerequisites
- Flutter SDK (3.x) installed and on your PATH.
- **Web**: Google Chrome installed.
- **Windows**: Visual Studio 2022 with C++ Desktop Development workload (for Windows desktop app).

### Installation
1. Navigate to the app directory:
   ```bash
   cd app
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Running the Application

**Web:**
```bash
flutter run -d chrome
```

**Windows:**
```bash
flutter run -d windows
```

## Testing
This project includes a comprehensive testing suite managed by a `Makefile` (and `test.bat` for Windows users).

### Running Tests
To run the full suite (Unit + Widget):
```bash
# Windows (Command Prompt/PowerShell)
.\test.bat

# Linux/Mac (or Windows with Make installed)
make test
```

### Test Categories
- **Unit Tests**: `make unit` - Tests individual logic (e.g., validators).
- **Widget Tests**: `make widget` - Tests UI components in isolation.
- **Integration Tests**: `make integration` - Runs full app flows on a device/emulator.

## Notable Dependencies
- `fl_chart`: For dashboard analytics visualization.
- `table_calendar`: For the appointment scheduling interface.
- `data_table_2`: For responsive data grids.
