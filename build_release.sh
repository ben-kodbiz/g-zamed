#!/bin/bash

echo "========================================"
echo "    MiniLM RAG System - Release Builder"
echo "========================================"
echo

echo "[1/6] Cleaning previous builds..."
flutter clean
if [ $? -ne 0 ]; then
    echo "Error: Flutter clean failed"
    exit 1
fi

echo "[2/6] Getting dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "Error: Failed to get dependencies"
    exit 1
fi

echo "[3/6] Generating database code..."
dart run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo "Error: Code generation failed"
    exit 1
fi

echo "[4/6] Running tests..."
flutter test
if [ $? -ne 0 ]; then
    echo "Warning: Some tests failed"
    read -p "Continue with build? (y/n): " continue
    if [ "$continue" != "y" ] && [ "$continue" != "Y" ]; then
        echo "Build cancelled"
        exit 1
    fi
fi

echo "[5/6] Building Android APK..."
flutter build apk --release
if [ $? -ne 0 ]; then
    echo "Error: APK build failed"
    exit 1
fi

echo "[6/6] Building Android App Bundle..."
flutter build appbundle --release
if [ $? -ne 0 ]; then
    echo "Error: App Bundle build failed"
    exit 1
fi

# Build iOS if on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "[7/7] Building iOS (detected macOS)..."
    flutter build ios --release
    if [ $? -ne 0 ]; then
        echo "Warning: iOS build failed"
    fi
fi

echo
echo "========================================"
echo "           BUILD COMPLETED!"
echo "========================================"
echo
echo "Release files generated:"
echo "- APK: build/app/outputs/flutter-apk/app-release.apk"
echo "- AAB: build/app/outputs/bundle/release/app-release.aab"
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "- iOS: build/ios/iphoneos/Runner.app"
fi
echo
echo "Ready for distribution!"