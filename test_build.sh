#!/bin/bash

echo "🎮 Building and Testing Tetris Game..."
echo "======================================"

# Navigate to project directory
cd /Users/apple/Documents/NCB/miniapp_project/miniapp_web

# Clean and get dependencies
echo "🧹 Cleaning project..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

# Build for web
echo "🔨 Building for web..."
flutter build web --release

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📁 Build files location: $(pwd)/build/web"
    echo "📋 Build contents:"
    ls -la build/web/
    echo ""
    echo "🌐 Starting local server..."
    echo "📱 Your game will be available at: http://localhost:8080"
    echo "🛑 Press Ctrl+C to stop the server"
    echo ""
    
    # Start Python server
    cd build/web
    python3 -m http.server 8080
else
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi
