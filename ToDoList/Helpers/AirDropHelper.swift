//
//  AirDropHelper.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import AppKit
import UniformTypeIdentifiers

class AirDropHelper {
    
    // Share a single todo item
    static func shareTodoItem(_ item: TodoItem) {
        let text = "\(item.isCompleted ? "✓" : "○") \(item.title)"
        shareText(text, filename: "todo-\(sanitizeFilename(item.title)).txt")
    }
    
    // Share a single note
    static func shareNote(_ note: Note) {
        let text = """
        \(note.title)
        
        \(note.content)
        """
        shareText(text, filename: "\(sanitizeFilename(note.title)).txt")
    }
    
    // Share an entire folder with all notes
    static func shareFolder(_ folder: DailyFolder) {
        var folderContent = "Folder: \(folder.displayName)\n"
        folderContent += "Date: \(formatDate(folder.date))\n"
        folderContent += String(repeating: "=", count: 50) + "\n\n"
        
        for (index, note) in folder.notes.enumerated() {
            folderContent += "Note #\(index + 1): \(note.title)\n"
            folderContent += String(repeating: "-", count: 40) + "\n"
            folderContent += "\(note.content)\n\n"
        }
        
        shareText(folderContent, filename: "\(sanitizeFilename(folder.displayName)).txt")
    }
    
    // Share all todos
    static func shareAllTodos(_ todos: [TodoItem]) {
        var content = "To-Do List\n"
        content += String(repeating: "=", count: 50) + "\n\n"
        
        for todo in todos {
            content += "\(todo.isCompleted ? "✓" : "○") \(todo.title)\n"
        }
        
        shareText(content, filename: "all-todos.txt")
    }
    
    // Core sharing function using NSSharingService
    private static func shareText(_ text: String, filename: String) {
        // Create temporary file
        let tempDir = FileManager.default.temporaryDirectory
        let fileURL = tempDir.appendingPathComponent(filename)
        
        do {
            try text.write(to: fileURL, atomically: true, encoding: .utf8)
            
            // Use NSSharingService for AirDrop
            DispatchQueue.main.async {
                let sharingService = NSSharingService(named: .sendViaAirDrop)
                
                if let service = sharingService {
                    // Get the main window to present from
                    if let window = NSApplication.shared.windows.first,
                       let contentView = window.contentView {
                        service.perform(withItems: [fileURL])
                    }
                } else {
                    // Fallback to sharing picker
                    let picker = NSSharingServicePicker(items: [fileURL])
                    if let window = NSApplication.shared.windows.first,
                       let contentView = window.contentView {
                        picker.show(relativeTo: .zero, of: contentView, preferredEdge: .minY)
                    }
                }
            }
        } catch {
            print("Error creating file for sharing: \(error)")
        }
    }
    
    // Helper to sanitize filename
    private static func sanitizeFilename(_ name: String) -> String {
        let invalidCharacters = CharacterSet(charactersIn: ":/\\?%*|\"<>")
        return name.components(separatedBy: invalidCharacters).joined(separator: "-")
            .trimmingCharacters(in: .whitespaces)
            .prefix(50)
            .description
    }
    
    // Helper to format date
    private static func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
