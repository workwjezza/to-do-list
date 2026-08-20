# ToDoList - Native macOS To-Do List & Daily Notes App

A clean, native macOS application for managing to-do items and daily notes with AirDrop sharing capabilities.

## Features

### ✅ To-Do List
- Add, complete, and delete tasks
- Clean checkbox interface with strikethrough for completed items
- Persistent storage using UserDefaults
- Share individual tasks via AirDrop

### 📁 Daily Notes Folders
- Create folders for organizing daily notes
- Each folder can contain multiple notes
- Click on folders to view and manage notes
- Expandable note view to see full content
- Share individual notes or entire folders via AirDrop

### 📤 AirDrop Integration
- Share individual to-do items to your iPhone/iPad
- Share individual notes
- Share entire folders with all notes
- Files are sent as .txt format compatible with Notes app and Files app

### 🎨 Design
- Clean white background with black text
- Native macOS folder icons (SF Symbols)
- Swift/SwiftUI design language
- Hover effects for interactive elements
- Minimal, distraction-free interface

## Requirements

- macOS 13.0 (Ventura) or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Installation & Setup

### Adding Your Custom App Icon

Before building, you may want to add your custom app icon:
1. See `ICON_SETUP.md` for detailed instructions
2. Drag your icon image into `Assets.xcassets/AppIcon` in Xcode
3. Xcode will automatically resize it for all required sizes

### Option 1: Open in Xcode

1. Open the project:
   ```bash
   open ToDoList.xcodeproj
   ```

2. In Xcode, select your development team:
   - Click on the project in the navigator
   - Select the "ToDoList" target
   - Go to "Signing & Capabilities"
   - Select your Team from the dropdown

3. Build and run the app (⌘R)

### Option 2: Build from Command Line

```bash
# Build the project
xcodebuild -project ToDoList.xcodeproj -scheme ToDoList -configuration Release build

# The app will be in:
# build/Release/ToDoList.app
```

## Usage

### Adding To-Do Items
1. Type your task in the text field at the top
2. Press Enter to add the task
3. Click the circle to mark as complete
4. Hover over items to see share and delete options

### Creating Daily Folders
1. Click the "+" button next to "Daily Notes"
2. Enter a folder name
3. Click "Create"

### Adding Notes to Folders
1. Click on a folder to open it
2. Click "New Note" at the bottom
3. Enter content (title is optional - leave blank for quick inspiration capture!)
4. Click "Create"
5. Notes without titles will show as "Untitled" in gray
6. Click on any note title (or "Untitled") to edit it later

### Sharing via AirDrop
1. Hover over any item (to-do, note, or folder)
2. Click the share icon (square with arrow)
3. Select your device from the AirDrop menu
4. Files will appear in Notes app or Files app on your iPhone/iPad

## Setting as Login Item

To make the app start automatically when you log in:

1. Open **System Settings** > **General** > **Login Items**
2. Click the "+" button under "Open at Login"
3. Navigate to and select the ToDoList app
4. The app will now launch automatically at login

Alternatively, you can drag the app to:
**System Settings** > **Users & Groups** > **Login Items**

## Project Structure

```
ToDoList/
├── ToDoListApp.swift          # Main app entry point
├── Models/
│   ├── TodoItem.swift         # To-do item data model
│   ├── Note.swift             # Note data model
│   └── DailyFolder.swift      # Folder data model
├── Views/
│   ├── ContentView.swift      # Main view with to-dos and folders
│   └── FolderDetailView.swift # Folder detail view with notes
├── Helpers/
│   ├── DataManager.swift      # Data persistence manager
│   └── AirDropHelper.swift    # AirDrop sharing functionality
├── Assets.xcassets/           # App icons and assets
├── Info.plist                 # App configuration
└── ToDoList.entitlements      # App permissions
```

## Data Persistence

All data is automatically saved using UserDefaults:
- To-do items are saved whenever you add, complete, or delete them
- Folders and notes are saved whenever you create or modify them
- Data persists between app launches

## Keyboard Shortcuts

- **Enter**: Add new to-do item or create new note/folder
- **Escape**: Cancel dialog/sheet
- **⌘W**: Close window
- **⌘Q**: Quit application

## Troubleshooting

### AirDrop not working
- Ensure both devices have WiFi and Bluetooth enabled
- Make sure AirDrop is set to "Everyone" or "Contacts Only" on receiving device
- Check that both devices are signed in with the same Apple ID (for Contacts Only)

### App won't build
- Ensure you have Xcode 15.0 or later installed
- Select a valid development team in Signing & Capabilities
- Clean build folder (⌘⇧K) and rebuild

### Data not persisting
- Check that the app has proper permissions
- Data is stored in UserDefaults and should persist automatically
- If issues persist, try deleting and reinstalling the app

## Future Enhancements

Potential features for future versions:
- iCloud sync across devices
- Tags and categories for to-dos
- Due dates and reminders
- Search functionality
- Export to PDF or other formats
- Themes and customization options
- Menu bar mode

## License

Copyright © 2026. All rights reserved.

## Support

For issues or questions, please create an issue in the project repository.

---

**Built with ❤️ using Swift and SwiftUI**
