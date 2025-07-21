@echo off
echo ========================================
echo    MiniLM RAG System - Release Builder
echo ========================================
echo.

echo [1/6] Cleaning previous builds...
flutter clean
if %errorlevel% neq 0 (
    echo Error: Flutter clean failed
    pause
    exit /b 1
)

echo [2/6] Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo Error: Failed to get dependencies
    pause
    exit /b 1
)

echo [3/6] Generating database code...
dart run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo Error: Code generation failed
    pause
    exit /b 1
)

echo [4/6] Running tests...
flutter test
if %errorlevel% neq 0 (
    echo Warning: Some tests failed
    set /p continue="Continue with build? (y/n): "
    if /i not "%continue%"=="y" (
        echo Build cancelled
        pause
        exit /b 1
    )
)

echo [5/6] Building Android APK...
flutter build apk --release
if %errorlevel% neq 0 (
    echo Error: APK build failed
    pause
    exit /b 1
)

echo [6/6] Building Android App Bundle...
flutter build appbundle --release
if %errorlevel% neq 0 (
    echo Error: App Bundle build failed
    pause
    exit /b 1
)

echo.
echo ========================================
echo           BUILD COMPLETED!
echo ========================================
echo.
echo Release files generated:
echo - APK: build\app\outputs\flutter-apk\app-release.apk
echo - AAB: build\app\outputs\bundle\release\app-release.aab
echo.
echo Ready for distribution!
pause