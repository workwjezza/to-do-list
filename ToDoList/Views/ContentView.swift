//
//  ContentView.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var newTodoText = ""
    @State private var newFolderName = ""
    @State private var showingNewFolderSheet = false
    @State private var showingHistory = false
    @State private var showingClearConfirmation = false
    @Environment(\.openWindow) private var openWindow
    
    var body: some View {
        HStack(spacing: 0) {
            // Main content area
            VStack(spacing: 0) {
                // Top toolbar
                HStack {
                    Spacer()
                    
                    // Clear to History button
                    Button(action: {
                        showingClearConfirmation = true
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "arrow.down.doc")
                                .font(.system(size: 12))
                            Text("Clear")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(.black.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .help("Clear current items to history")
                    .disabled(dataManager.todoItems.isEmpty && dataManager.dailyFolders.isEmpty)
                    
                    // History toggle button
                    Button(action: {
                        withAnimation {
                            showingHistory.toggle()
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.system(size: 12))
                            Text("History")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(showingHistory ? .blue : .black.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .help("Toggle history sidebar")
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(Color.white)
                
                Divider()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        // To-Do List Section
                        todoListSection
                        
                        Divider()
                            .padding(.vertical, 8)
                        
                        // Daily Folders Section
                        dailyFoldersSection
                    }
                    .padding(20)
                }
                .background(Color.white)
            }
            
            // History sidebar
            if showingHistory {
                Divider()
                
                historySidebar
                    .frame(width: 250)
                    .transition(.move(edge: .trailing))
            }
        }
        .sheet(isPresented: $showingNewFolderSheet) {
            newFolderSheet
        }
        .alert("Clear to History?", isPresented: $showingClearConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Clear", role: .destructive) {
                dataManager.clearToHistory()
            }
        } message: {
            Text("This will move all current to-dos and folders to history and start fresh.")
        }
    }
    
    // MARK: - To-Do List Section
    
    private var todoListSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Add new todo
            HStack(spacing: 8) {
                Image(systemName: "circle")
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                
                TextField("Add new task...", text: $newTodoText)
                    .textFieldStyle(.plain)
                    .font(.system(size: 14))
                    .onSubmit {
                        addNewTodo()
                    }
            }
            .padding(.vertical, 4)
            
            // Existing todos
            ForEach(dataManager.todoItems) { item in
                TodoItemRow(item: item)
            }
        }
    }
    
    // MARK: - Daily Folders Section
    
    private var dailyFoldersSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Daily Notes")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.black.opacity(0.6))
                
                Spacer()
                
                Button(action: { showingNewFolderSheet = true }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.black.opacity(0.5))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
            }
            
            // Folder list
            ForEach(dataManager.dailyFolders) { folder in
                FolderRow(folder: folder, onTap: {
                    openWindow(id: "folder", value: folder.id)
                })
            }
        }
    }
    
    // MARK: - New Folder Sheet
    
    private var newFolderSheet: some View {
        VStack(spacing: 20) {
            Text("New Folder")
                .font(.system(size: 18, weight: .semibold))
            
            TextField("Folder name", text: $newFolderName)
                .textFieldStyle(.roundedBorder)
                .frame(width: 250)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    showingNewFolderSheet = false
                    newFolderName = ""
                }
                .keyboardShortcut(.escape)
                
                Button("Create") {
                    if !newFolderName.isEmpty {
                        dataManager.addDailyFolder(name: newFolderName)
                        showingNewFolderSheet = false
                        newFolderName = ""
                    }
                }
                .keyboardShortcut(.return)
                .disabled(newFolderName.isEmpty)
            }
        }
        .padding(30)
        .frame(width: 350, height: 180)
    }
    
    // MARK: - History Sidebar
    
    private var historySidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Sidebar header
            HStack {
                Text("History")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding(16)
            .background(Color.white)
            
            Divider()
            
            // History list
            ScrollView {
                if dataManager.historySnapshots.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "clock")
                            .font(.system(size: 30))
                            .foregroundColor(.black.opacity(0.2))
                        
                        Text("No history yet")
                            .font(.system(size: 12))
                            .foregroundColor(.black.opacity(0.4))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(dataManager.historySnapshots) { snapshot in
                            HistorySnapshotRow(snapshot: snapshot)
                        }
                    }
                    .padding(12)
                }
            }
            .background(Color.white)
        }
        .background(Color.white)
    }
    
    // MARK: - Actions
    
    private func addNewTodo() {
        guard !newTodoText.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        dataManager.addTodoItem(newTodoText)
        newTodoText = ""
    }
}

// MARK: - History Snapshot Row

struct HistorySnapshotRow: View {
    @EnvironmentObject var dataManager: DataManager
    let snapshot: HistorySnapshot
    @State private var isHovering = false
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(snapshot.displayDate)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.black)
                    
                    HStack(spacing: 8) {
                        if snapshot.todoItems.count > 0 {
                            Text("\(snapshot.todoItems.count) tasks")
                                .font(.system(size: 10))
                                .foregroundColor(.black.opacity(0.5))
                        }
                        if snapshot.dailyFolders.count > 0 {
                            Text("\(snapshot.dailyFolders.count) folders")
                                .font(.system(size: 10))
                                .foregroundColor(.black.opacity(0.5))
                        }
                    }
                }
                
                Spacer()
                
                if isHovering {
                    HStack(spacing: 6) {
                        Button(action: {
                            dataManager.restoreFromHistory(snapshot)
                        }) {
                            Image(systemName: "arrow.up.doc")
                                .foregroundColor(.blue.opacity(0.7))
                                .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                        .help("Restore")
                        
                        Button(action: {
                            dataManager.deleteHistorySnapshot(snapshot)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.7))
                                .font(.system(size: 11))
                        }
                        .buttonStyle(.plain)
                        .help("Delete")
                    }
                }
                
                Button(action: { isExpanded.toggle() }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.black.opacity(0.4))
                        .font(.system(size: 9))
                }
                .buttonStyle(.plain)
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 6) {
                    if !snapshot.todoItems.isEmpty {
                        Text("Tasks:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                        
                        ForEach(snapshot.todoItems.prefix(3)) { item in
                            Text("• \(item.title)")
                                .font(.system(size: 10))
                                .foregroundColor(.black.opacity(0.5))
                                .lineLimit(1)
                        }
                        if snapshot.todoItems.count > 3 {
                            Text("  +\(snapshot.todoItems.count - 3) more")
                                .font(.system(size: 9))
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                    
                    if !snapshot.dailyFolders.isEmpty {
                        Text("Folders:")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.black.opacity(0.6))
                            .padding(.top, 4)
                        
                        ForEach(snapshot.dailyFolders.prefix(3)) { folder in
                            Text("📁 \(folder.displayName)")
                                .font(.system(size: 10))
                                .foregroundColor(.black.opacity(0.5))
                                .lineLimit(1)
                        }
                        if snapshot.dailyFolders.count > 3 {
                            Text("  +\(snapshot.dailyFolders.count - 3) more")
                                .font(.system(size: 9))
                                .foregroundColor(.black.opacity(0.4))
                        }
                    }
                }
                .padding(.leading, 8)
                .padding(.top, 4)
            }
        }
        .padding(10)
        .background(isHovering ? Color.black.opacity(0.03) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .cornerRadius(6)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

// MARK: - Todo Item Row

struct TodoItemRow: View {
    @EnvironmentObject var dataManager: DataManager
    let item: TodoItem
    @State private var isHovering = false
    @State private var showingShareMenu = false
    
    var body: some View {
        HStack(spacing: 8) {
            Button(action: {
                dataManager.toggleTodoItem(item)
            }) {
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(.black)
                    .font(.system(size: 16))
            }
            .buttonStyle(.plain)
            
            Text(item.title)
                .font(.system(size: 14))
                .foregroundColor(.black)
                .strikethrough(item.isCompleted)
            
            Spacer()
            
            if isHovering {
                HStack(spacing: 8) {
                    // AirDrop button
                    Button(action: {
                        AirDropHelper.shareTodoItem(item)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.black.opacity(0.5))
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .help("Share via AirDrop")
                    
                    // Delete button
                    Button(action: {
                        dataManager.deleteTodoItem(item)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red.opacity(0.7))
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 4)
        .onHover { hovering in
            isHovering = hovering
        }
    }
}

// MARK: - Folder Row

struct FolderRow: View {
    @EnvironmentObject var dataManager: DataManager
    let folder: DailyFolder
    let onTap: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "folder.fill")
                .foregroundColor(.blue.opacity(0.7))
                .font(.system(size: 18))
            
            Text(folder.displayName)
                .font(.system(size: 14))
                .foregroundColor(.black)
            
            if folder.notes.count > 0 {
                Text("(\(folder.notes.count))")
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.5))
            }
            
            Spacer()
            
            if isHovering {
                HStack(spacing: 8) {
                    // AirDrop button
                    Button(action: {
                        AirDropHelper.shareFolder(folder)
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .foregroundColor(.black.opacity(0.5))
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                    .help("Share folder via AirDrop")
                    
                    // Delete button
                    Button(action: {
                        dataManager.deleteDailyFolder(folder)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red.opacity(0.7))
                            .font(.system(size: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
        .background(isHovering ? Color.black.opacity(0.03) : Color.clear)
        .cornerRadius(6)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            onTap()
        }
        .contentShape(Rectangle())
    }
}

#Preview {
    ContentView()
        .environmentObject(DataManager.shared)
        .frame(width: 400, height: 600)
}
