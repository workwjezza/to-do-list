//
//  NoteEditorView.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import SwiftUI

struct NoteEditorView: View {
    @EnvironmentObject var dataManager: DataManager
    let folder: DailyFolder
    let note: Note
    
    @State private var editedTitle: String
    @State private var editedContent: String
    @FocusState private var isContentFocused: Bool
    
    init(folder: DailyFolder, note: Note) {
        self.folder = folder
        self.note = note
        _editedTitle = State(initialValue: note.title)
        _editedContent = State(initialValue: note.content)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with title
            HStack {
                TextField("Note title", text: $editedTitle)
                    .textFieldStyle(.plain)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                    .onChange(of: editedTitle) { _ in
                        saveChanges()
                    }
                
                Spacer()
            }
            .padding(20)
            .background(Color.white)
            
            Divider()
            
            // Content editor
            ZStack(alignment: .topLeading) {
                if editedContent.isEmpty {
                    Text("Start typing... (Shift+Enter for new line, Enter to save)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray.opacity(0.5))
                        .padding(.top, 8)
                        .padding(.leading, 5)
                }
                
                TextEditor(text: $editedContent)
                    .font(.system(size: 14))
                    .focused($isContentFocused)
                    .scrollContentBackground(.hidden)
                    .background(Color.white)
                    .onChange(of: editedContent) { _ in
                        saveChanges()
                    }
                    .onAppear {
                        isContentFocused = true
                    }
            }
            .padding(20)
            .background(Color.white)
            
            Divider()
            
            // Footer with auto-save indicator
            HStack {
                Text("Changes saved automatically • Shift+Enter for new line")
                    .font(.system(size: 11))
                    .foregroundColor(.gray.opacity(0.6))
                
                Spacer()
            }
            .padding(16)
            .background(Color.white)
        }
        .frame(width: 500, height: 400)
        .background(Color.white)
    }
    
    private func saveChanges() {
        dataManager.updateNote(folder, note: note, title: editedTitle, content: editedContent)
    }
}

#Preview {
    NoteEditorView(
        folder: DailyFolder(name: "Today", date: Date()),
        note: Note(title: "Sample Note", content: "This is some content")
    )
    .environmentObject(DataManager.shared)
}
