#!/bin/bash

echo "🚀 Preparing for Netlify deployment..."
echo "====================================="

# Build the project
echo "🔨 Building Flutter web app..."
flutter build web --release --web-renderer html

# Check if build was successful
if [ $? -eq 0 ]; then
    echo "✅ Build successful!"
    echo ""
    echo "📁 Files ready for deployment in: build/web/"
    echo "📋 Deployment files:"
    ls -la build/web/
    echo ""
    echo "🌐 Ready for Netlify deployment!"
    echo ""
    echo "📝 Deployment steps:"
    echo "1. Go to https://app.netlify.com"
    echo "2. Click 'Add new site' > 'Deploy manually'"
    echo "3. Drag and drop the 'build/web' folder"
    echo "4. Your Tetris game will be live!"
    echo ""
    echo "🔧 Or use Netlify CLI:"
    echo "npm install -g netlify-cli"
    echo "netlify deploy --prod --dir=build/web"
else
    echo "❌ Build failed! Check the error messages above."
    exit 1
fi
