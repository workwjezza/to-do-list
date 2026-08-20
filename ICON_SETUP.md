# App Icon Setup Instructions

## Adding Your Custom Icon

You've provided a custom icon image that needs to be added to the app. Here's how to do it:

### Method 1: Using Xcode (Recommended)

1. Open `ToDoList.xcodeproj` in Xcode
2. In the Project Navigator, navigate to:
   - `ToDoList` → `Assets.xcassets` → `AppIcon`
3. Drag and drop your icon image into the AppIcon slots
4. Xcode will automatically resize it for all required sizes

### Method 2: Manual Setup

Your icon needs to be provided in the following sizes for macOS:

- **16x16** (1x and 2x = 32x32)
- **32x32** (1x and 2x = 64x64)
- **128x128** (1x and 2x = 256x256)
- **256x256** (1x and 2x = 512x512)
- **512x512** (1x and 2x = 1024x1024)

### Steps to Add Icons Manually:

1. Save your icon image
2. Use an image editor or online tool to create all required sizes
3. Name them appropriately:
   - `icon_16x16.png`
   - `icon_16x16@2x.png` (32x32)
   - `icon_32x32.png`
   - `icon_32x32@2x.png` (64x64)
   - `icon_128x128.png`
   - `icon_128x128@2x.png` (256x256)
   - `icon_256x256.png`
   - `icon_256x256@2x.png` (512x512)
   - `icon_512x512.png`
   - `icon_512x512@2x.png` (1024x1024)

4. Place them in: `ToDoList/Assets.xcassets/AppIcon.appiconset/`

5. Update the `Contents.json` file in that directory to reference your images

### Quick Method Using sips (macOS Command Line):

If you have your source icon saved as `icon.png`, run these commands:

```bash
cd ToDoList/Assets.xcassets/AppIcon.appiconset/

# Create all sizes
sips -z 16 16 icon.png --out icon_16x16.png
sips -z 32 32 icon.png --out icon_16x16@2x.png
sips -z 32 32 icon.png --out icon_32x32.png
sips -z 64 64 icon.png --out icon_32x32@2x.png
sips -z 128 128 icon.png --out icon_128x128.png
sips -z 256 256 icon.png --out icon_128x128@2x.png
sips -z 256 256 icon.png --out icon_256x256.png
sips -z 512 512 icon.png --out icon_256x256@2x.png
sips -z 512 512 icon.png --out icon_512x512.png
sips -z 1024 1024 icon.png --out icon_512x512@2x.png
```

### Using Online Tools:

You can also use online icon generators like:
- https://appicon.co/
- https://makeappicon.com/

Just upload your image and download the macOS icon set.

## Current Icon Status

The app currently has a placeholder icon configuration. Once you add your custom icon following the steps above, rebuild the app in Xcode to see your new icon!
