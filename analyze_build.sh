#!/bin/bash

echo "🔍 Analyzing Flutter Web Build..."
echo "================================="

BUILD_DIR="/Users/apple/Documents/NCB/miniapp_project/miniapp_web/build/web"

if [ -d "$BUILD_DIR" ]; then
    echo "📁 Build directory exists: $BUILD_DIR"
    echo ""
    
    echo "📋 Build contents:"
    ls -la "$BUILD_DIR"
    echo ""
    
    echo "📊 File sizes:"
    du -h "$BUILD_DIR"/* 2>/dev/null | sort -hr
    echo ""
    
    echo "🔧 Key files check:"
    
    # Check essential files
    files=("index.html" "main.dart.js" "flutter.js" "manifest.json")
    
    for file in "${files[@]}"; do
        if [ -f "$BUILD_DIR/$file" ]; then
            echo "✅ $file exists ($(du -h "$BUILD_DIR/$file" | cut -f1))"
        else
            echo "❌ $file missing"
        fi
    done
    
    echo ""
    echo "🌐 Assets check:"
    if [ -d "$BUILD_DIR/assets" ]; then
        echo "✅ Assets directory exists"
        echo "📦 Asset files:"
        find "$BUILD_DIR/assets" -type f | head -10
    else
        echo "❌ Assets directory missing"
    fi
    
    echo ""
    echo "🎮 Ready to test! Run:"
    echo "cd $BUILD_DIR && python3 -m http.server 8080"
    
else
    echo "❌ Build directory not found!"
    echo "Run 'flutter build web' first."
fi
