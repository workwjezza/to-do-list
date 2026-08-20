#!/bin/bash

# Script to set up app icons and fix Xcode issues
# This script will:
# 1. Clean Xcode derived data to fix parse errors
# 2. Set up the app icon structure

echo "🧹 Cleaning Xcode derived data to fix parse errors..."
rm -rf ~/Library/Developer/Xcode/DerivedData/ToDoList-*

echo "✅ Xcode cache cleaned!"
echo ""
echo "📱 App icon setup:"
echo "   The icon structure is ready in: ToDoList/Assets.xcassets/AppIcon.appiconset/"
echo ""
echo "🌍 To add your earth icons:"
echo "   1. Save your two earth images (1024x1024 and smaller size)"
echo "   2. Open Xcode"
echo "   3. Navigate to ToDoList/Assets.xcassets/AppIcon"
echo "   4. Drag and drop your earth icon images into the appropriate size slots"
echo "   5. Xcode will automatically resize them for all required sizes"
echo ""
echo "   OR use the command line:"
echo "   - Copy your 1024x1024 earth icon to: ToDoList/Assets.xcassets/AppIcon.appiconset/icon_512x512@2x.png"
echo "   - Copy your 512x512 earth icon to: ToDoList/Assets.xcassets/AppIcon.appiconset/icon_512x512.png"
echo ""
echo "✨ Done! Now open the project in Xcode and it should work without parse errors."
