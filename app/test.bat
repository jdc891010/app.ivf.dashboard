@echo off
REM Windows Test Script for IVF Dashboard

IF "%1"=="" GOTO ALL
IF "%1"=="test" GOTO ALL
IF "%1"=="unit" GOTO UNIT
IF "%1"=="widget" GOTO WIDGET
IF "%1"=="integration" GOTO INTEGRATION
IF "%1"=="clean" GOTO CLEAN
IF "%1"=="help" GOTO HELP

:ALL
echo Running all tests (Unit + Widget)...
flutter test test/unit test/widget
GOTO END

:UNIT
echo Running unit tests...
flutter test test/unit
GOTO END

:WIDGET
echo Running widget tests...
flutter test test/widget
GOTO END

:INTEGRATION
echo Running integration tests...
flutter test -d windows integration_test
GOTO END

:CLEAN
echo Cleaning project...
flutter clean
flutter pub get
GOTO END

:HELP
echo Available commands:
echo   test.bat             - Run unit and widget tests
echo   test.bat unit        - Run unit tests only
echo   test.bat widget      - Run widget tests only
echo   test.bat integration - Run integration tests
echo   test.bat clean       - Clean project
GOTO END

:END
