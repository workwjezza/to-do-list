//
//  DataManager.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    static let shared = DataManager()
    
    @Published var todoItems: [TodoItem] = []
    @Published var dailyFolders: [DailyFolder] = []
    @Published var historySnapshots: [HistorySnapshot] = []
    
    private let todosKey = "savedTodoItems"
    private let foldersKey = "savedDailyFolders"
    private let historyKey = "savedHistorySnapshots"
    
    private init() {
        loadData()
    }
    
    // MARK: - Todo Items
    
    func addTodoItem(_ title: String) {
        let newItem = TodoItem(title: title)
        todoItems.append(newItem)
        saveTodos()
    }
    
    func toggleTodoItem(_ item: TodoItem) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].isCompleted.toggle()
            saveTodos()
        }
    }
    
    func deleteTodoItem(_ item: TodoItem) {
        todoItems.removeAll { $0.id == item.id }
        saveTodos()
    }
    
    func updateTodoItem(_ item: TodoItem, title: String) {
        if let index = todoItems.firstIndex(where: { $0.id == item.id }) {
            todoItems[index].title = title
            saveTodos()
        }
    }
    
    // MARK: - Daily Folders
    
    func addDailyFolder(name: String) {
        let newFolder = DailyFolder(name: name, date: Date())
        dailyFolders.insert(newFolder, at: 0)
        saveFolders()
    }
    
    func deleteDailyFolder(_ folder: DailyFolder) {
        dailyFolders.removeAll { $0.id == folder.id }
        saveFolders()
    }
    
    func addNoteToFolder(_ folder: DailyFolder, title: String, content: String) {
        if let index = dailyFolders.firstIndex(where: { $0.id == folder.id }) {
            let newNote = Note(title: title, content: content)
            dailyFolders[index].notes.append(newNote)
            saveFolders()
        }
    }
    
    func deleteNoteFromFolder(_ folder: DailyFolder, note: Note) {
        if let folderIndex = dailyFolders.firstIndex(where: { $0.id == folder.id }) {
            dailyFolders[folderIndex].notes.removeAll { $0.id == note.id }
            saveFolders()
        }
    }
    
    func updateNote(_ folder: DailyFolder, note: Note, title: String, content: String) {
        if let folderIndex = dailyFolders.firstIndex(where: { $0.id == folder.id }),
           let noteIndex = dailyFolders[folderIndex].notes.firstIndex(where: { $0.id == note.id }) {
            dailyFolders[folderIndex].notes[noteIndex].title = title
            dailyFolders[folderIndex].notes[noteIndex].content = content
            saveFolders()
        }
    }
    
    // MARK: - History
    
    func clearToHistory() {
        // Create snapshot of current state
        let snapshot = HistorySnapshot(
            date: Date(),
            todoItems: todoItems,
            dailyFolders: dailyFolders
        )
        
        // Add to history
        historySnapshots.insert(snapshot, at: 0)
        
        // Clear current items
        todoItems = []
        dailyFolders = []
        
        // Save everything
        saveTodos()
        saveFolders()
        saveHistory()
    }
    
    func deleteHistorySnapshot(_ snapshot: HistorySnapshot) {
        historySnapshots.removeAll { $0.id == snapshot.id }
        saveHistory()
    }
    
    func restoreFromHistory(_ snapshot: HistorySnapshot) {
        // Save current state to history first if not empty
        if !todoItems.isEmpty || !dailyFolders.isEmpty {
            clearToHistory()
        }
        
        // Restore from snapshot
        todoItems = snapshot.todoItems
        dailyFolders = snapshot.dailyFolders
        
        // Remove the snapshot from history
        historySnapshots.removeAll { $0.id == snapshot.id }
        
        // Save everything
        saveTodos()
        saveFolders()
        saveHistory()
    }
    
    // MARK: - Persistence
    
    private func saveTodos() {
        if let encoded = try? JSONEncoder().encode(todoItems) {
            UserDefaults.standard.set(encoded, forKey: todosKey)
        }
    }
    
    private func saveFolders() {
        if let encoded = try? JSONEncoder().encode(dailyFolders) {
            UserDefaults.standard.set(encoded, forKey: foldersKey)
        }
    }
    
    private func saveHistory() {
        if let encoded = try? JSONEncoder().encode(historySnapshots) {
            UserDefaults.standard.set(encoded, forKey: historyKey)
        }
    }
    
    private func loadData() {
        // Load todos
        if let savedTodos = UserDefaults.standard.data(forKey: todosKey),
           let decodedTodos = try? JSONDecoder().decode([TodoItem].self, from: savedTodos) {
            todoItems = decodedTodos
        }
        
        // Load folders
        if let savedFolders = UserDefaults.standard.data(forKey: foldersKey),
           let decodedFolders = try? JSONDecoder().decode([DailyFolder].self, from: savedFolders) {
            dailyFolders = decodedFolders
        }
        
        // Load history
        if let savedHistory = UserDefaults.standard.data(forKey: historyKey),
           let decodedHistory = try? JSONDecoder().decode([HistorySnapshot].self, from: savedHistory) {
            historySnapshots = decodedHistory
        }
    }
}
