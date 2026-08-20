#!/bin/bash

# Script to generate all required macOS app icon sizes
# Source: todolist-icon2x.png (1024x1024)

SOURCE_ICON="todolist-icon2x.png"
DEST_DIR="ToDoList/Assets.xcassets/AppIcon.appiconset"

echo "Generating macOS app icons from $SOURCE_ICON..."

# Create the destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Generate all required sizes using sips (built-in macOS tool)
sips -z 16 16 "$SOURCE_ICON" --out "$DEST_DIR/icon_16x16.png"
sips -z 32 32 "$SOURCE_ICON" --out "$DEST_DIR/icon_16x16@2x.png"
sips -z 32 32 "$SOURCE_ICON" --out "$DEST_DIR/icon_32x32.png"
sips -z 64 64 "$SOURCE_ICON" --out "$DEST_DIR/icon_32x32@2x.png"
sips -z 128 128 "$SOURCE_ICON" --out "$DEST_DIR/icon_128x128.png"
sips -z 256 256 "$SOURCE_ICON" --out "$DEST_DIR/icon_128x128@2x.png"
sips -z 256 256 "$SOURCE_ICON" --out "$DEST_DIR/icon_256x256.png"
sips -z 512 512 "$SOURCE_ICON" --out "$DEST_DIR/icon_256x256@2x.png"
sips -z 512 512 "$SOURCE_ICON" --out "$DEST_DIR/icon_512x512.png"
sips -z 1024 1024 "$SOURCE_ICON" --out "$DEST_DIR/icon_512x512@2x.png"

echo "✅ All icon sizes generated successfully!"
echo "Icons created in: $DEST_DIR"
echo ""
echo "Generated files:"
ls -lh "$DEST_DIR"/*.png 2>/dev/null || echo "No PNG files found"
