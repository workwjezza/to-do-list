//
//  FolderDetailView.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import SwiftUI

struct FolderDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.openWindow) private var openWindow
    let folder: DailyFolder
    
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var showingNewNoteSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Image(systemName: "folder.fill")
                    .foregroundColor(.blue.opacity(0.7))
                    .font(.system(size: 20))
                
                Text(folder.displayName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Button(action: {
                    AirDropHelper.shareFolder(folder)
                }) {
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.black.opacity(0.6))
                        .font(.system(size: 16))
                }
                .buttonStyle(.plain)
                .help("Share entire folder via AirDrop")
            }
            .padding(20)
            .background(Color.white)
            
            Divider()
            
            // Notes list
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    if currentFolder.notes.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "note.text")
                                .font(.system(size: 40))
                                .foregroundColor(.black.opacity(0.2))
                            
                            Text("No notes yet")
                                .font(.system(size: 14))
                                .foregroundColor(.black.opacity(0.4))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 60)
                    } else {
                        ForEach(currentFolder.notes) { note in
                            NoteRow(folder: folder, note: note, onDoubleClick: {
                                let noteId = NoteIdentifier(folderId: folder.id, noteId: note.id)
                                openWindow(id: "note", value: noteId)
                            })
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.white)
            
            Divider()
            
            // Add note button
            HStack {
                Button(action: { showingNewNoteSheet = true }) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Note")
                    }
                    .font(.system(size: 14))
                    .foregroundColor(.black)
                }
                .buttonStyle(.plain)
                
                Spacer()
            }
            .padding(16)
            .background(Color.white)
        }
        .frame(width: 500, height: 600)
        .background(Color.white)
        .sheet(isPresented: $showingNewNoteSheet) {
            newNoteSheet
        }
    }
    
    private var currentFolder: DailyFolder {
        dataManager.dailyFolders.first(where: { $0.id == folder.id }) ?? folder
    }
    
    // MARK: - New Note Sheet
    
    private var newNoteSheet: some View {
        VStack(spacing: 20) {
            Text("New Note")
                .font(.system(size: 18, weight: .semibold))
            
            VStack(alignment: .leading, spacing: 12) {
                TextField("Note title (optional)", text: $newNoteTitle)
                    .textFieldStyle(.roundedBorder)
                
                Text("Content:")
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.6))
                
                TextEditor(text: $newNoteContent)
                    .font(.system(size: 13))
                    .frame(height: 150)
                    .border(Color.black.opacity(0.2), width: 1)
            }
            .frame(width: 350)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    showingNewNoteSheet = false
                    newNoteTitle = ""
                    newNoteContent = ""
                }
                .keyboardShortcut(.escape)
                
                Button("Create") {
                    // Allow creating notes without titles
                    let title = newNoteTitle.isEmpty ? "" : newNoteTitle
                    dataManager.addNoteToFolder(folder, title: title, content: newNoteContent)
                    showingNewNoteSheet = false
                    newNoteTitle = ""
                    newNoteContent = ""
                }
                .keyboardShortcut(.return)
            }
        }
        .padding(30)
        .frame(width: 450, height: 350)
    }
}

// MARK: - Note Row

struct NoteRow: View {
    @EnvironmentObject var dataManager: DataManager
    let folder: DailyFolder
    let note: Note
    let onDoubleClick: () -> Void
    @State private var isHovering = false
    @State private var isExpanded = false
    @State private var isEditingTitle = false
    @State private var editedTitle = ""
    @FocusState private var isTitleFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "doc.text")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.system(size: 14))
                
                if isEditingTitle {
                    TextField("Note title", text: $editedTitle)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .focused($isTitleFocused)
                        .onSubmit {
                            saveTitle()
                        }
                        .onAppear {
                            isTitleFocused = true
                        }
                } else {
                    Text(note.title.isEmpty ? "Untitled" : note.title)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(note.title.isEmpty ? .gray.opacity(0.6) : .black)
                        .onTapGesture {
                            startEditingTitle()
                        }
                }
                
                Spacer()
                
                if isHovering && !isEditingTitle {
                    HStack(spacing: 8) {
                        // Edit title button
                        Button(action: {
                            startEditingTitle()
                        }) {
                            Image(systemName: "pencil")
                                .foregroundColor(.black.opacity(0.5))
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("Edit title")
                        
                        // AirDrop button
                        Button(action: {
                            AirDropHelper.shareNote(note)
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.black.opacity(0.5))
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                        .help("Share note via AirDrop")
                        
                        // Delete button
                        Button(action: {
                            dataManager.deleteNoteFromFolder(folder, note: note)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red.opacity(0.7))
                                .font(.system(size: 12))
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                if !isEditingTitle {
                    Button(action: { isExpanded.toggle() }) {
                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .foregroundColor(.black.opacity(0.4))
                            .font(.system(size: 10))
                    }
                    .buttonStyle(.plain)
                }
            }
            
            if isExpanded && !note.content.isEmpty {
                Text(note.content)
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.7))
                    .padding(.leading, 22)
                    .padding(.top, 4)
            }
        }
        .padding(12)
        .background(isHovering ? Color.black.opacity(0.03) : Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 6)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .cornerRadius(6)
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture(count: 2) {
            onDoubleClick()
        }
        .help("Double-click to open note editor")
    }
    
    private func startEditingTitle() {
        editedTitle = note.title
        isEditingTitle = true
    }
    
    private func saveTitle() {
        dataManager.updateNote(folder, note: note, title: editedTitle, content: note.content)
        isEditingTitle = false
    }
}

#Preview {
    FolderDetailView(folder: DailyFolder(name: "Today", date: Date(), notes: [
        Note(title: "Meeting Notes", content: "Discuss project timeline"),
        Note(title: "Ideas", content: "New feature concepts")
    ]))
    .environmentObject(DataManager.shared)
}
