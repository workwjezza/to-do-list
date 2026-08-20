//
//  ToDoListApp.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import SwiftUI

@main
struct ToDoListApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject private var dataManager = DataManager.shared
    
    var body: some Scene {
        WindowGroup("To-Do List", id: "main") {
            ContentView()
                .environmentObject(dataManager)
                .frame(minWidth: 400, minHeight: 500)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .commands {
            CommandGroup(replacing: .newItem) { }
        }
        
        // Folder detail windows
        WindowGroup("Folder", id: "folder", for: DailyFolder.ID.self) { $folderId in
            if let folderId = folderId,
               let folder = dataManager.dailyFolders.first(where: { $0.id == folderId }) {
                FolderDetailView(folder: folder)
                    .environmentObject(dataManager)
            }
        }
        .windowResizability(.contentSize)
        
        // Note editor windows
        WindowGroup("Note", id: "note", for: NoteIdentifier.self) { $noteId in
            if let noteId = noteId,
               let folder = dataManager.dailyFolders.first(where: { $0.id == noteId.folderId }),
               let note = folder.notes.first(where: { $0.id == noteId.noteId }) {
                NoteEditorView(folder: folder, note: note)
                    .environmentObject(dataManager)
            }
        }
        .windowResizability(.contentSize)
    }
}

// Helper struct to identify notes across folders
struct NoteIdentifier: Codable, Hashable {
    let folderId: UUID
    let noteId: UUID
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Configure window appearance
        if let window = NSApplication.shared.windows.first {
            window.titlebarAppearsTransparent = true
            window.titleVisibility = .hidden
            window.backgroundColor = .white
        }
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
