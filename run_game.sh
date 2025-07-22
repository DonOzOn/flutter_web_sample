#!/bin/bash

echo "🎮 Starting Tetris Game..."
echo "📁 Current directory: $(pwd)"

# Clean and get dependencies
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🚀 Running Flutter web app..."
flutter run -d web-server --web-port 8080 --web-renderer html
