//
//  FolderDetailView.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import SwiftUI
import UniformTypeIdentifiers

struct FolderDetailView: View {
    @EnvironmentObject var dataManager: DataManager
    @Environment(\.openWindow) private var openWindow
    let folder: DailyFolder
    
    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var showingNewNoteSheet = false
    @State private var isDraggingOver = false
    
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
            
            // Scrollable content area with notes and media
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Notes section
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
                    
                    Divider()
                    
                    // Media section
                    mediaSection
                }
            }
            .background(Color.white)
        }
        .frame(minWidth: 400, idealWidth: 500, minHeight: 400, idealHeight: 600)
        .background(Color.white)
        .sheet(isPresented: $showingNewNoteSheet) {
            newNoteSheet
        }
    }
    
    private var currentFolder: DailyFolder {
        dataManager.dailyFolders.first(where: { $0.id == folder.id }) ?? folder
    }
    
    // MARK: - Media Section
    
    private var mediaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Media")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)
                
                Spacer()
                
                Text("\(currentFolder.mediaItems.count)/100")
                    .font(.system(size: 12))
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            
            // Drag and drop zone
            ZStack {
                // Grid of media items
                if currentFolder.mediaItems.isEmpty {
                    VStack(spacing: 12) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 40))
                            .foregroundColor(.black.opacity(0.2))
                        
                        Text("Drag photos here")
                            .font(.system(size: 14))
                            .foregroundColor(.black.opacity(0.4))
                        
                        Text("Up to 100 images")
                            .font(.system(size: 11))
                            .foregroundColor(.black.opacity(0.3))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 200)
                } else {
                    mediaGrid
                }
            }
            .frame(maxWidth: .infinity)
            .background(isDraggingOver ? Color.blue.opacity(0.1) : Color.black.opacity(0.02))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isDraggingOver ? Color.blue.opacity(0.5) : Color.black.opacity(0.1),
                        style: StrokeStyle(lineWidth: 2, dash: isDraggingOver ? [8, 4] : [])
                    )
            )
            .cornerRadius(8)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            .onDrop(of: [.fileURL], isTargeted: $isDraggingOver) { providers in
                handleDrop(providers: providers)
                return true
            }
        }
    }
    
    private var mediaGrid: some View {
        let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
        
        return LazyVGrid(columns: columns, spacing: 8) {
            ForEach(currentFolder.mediaItems) { mediaItem in
                MediaThumbnail(mediaItem: mediaItem, folder: folder)
            }
        }
        .padding(12)
    }
    
    private func handleDrop(providers: [NSItemProvider]) {
        // Limit to 100 items
        guard currentFolder.mediaItems.count < 100 else { return }
        
        for provider in providers {
            provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { (urlData, error) in
                DispatchQueue.main.async {
                    if let urlData = urlData as? Data,
                       let url = URL(dataRepresentation: urlData, relativeTo: nil),
                       let imageData = try? Data(contentsOf: url),
                       let _ = NSImage(data: imageData) {
                        
                        // Check limit again before adding
                        if currentFolder.mediaItems.count < 100 {
                            let fileName = url.lastPathComponent
                            dataManager.addMediaToFolder(folder, imageData: imageData, fileName: fileName)
                        }
                    }
                }
            }
        }
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

// MARK: - Media Thumbnail

struct MediaThumbnail: View {
    @EnvironmentObject var dataManager: DataManager
    let mediaItem: MediaItem
    let folder: DailyFolder
    @State private var isHovering = false
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            if let image = mediaItem.image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 105, height: 105)
                    .clipped()
                    .cornerRadius(6)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.black.opacity(0.1), lineWidth: 1)
                    )
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 105, height: 105)
                    .cornerRadius(6)
            }
            
            // Delete button on hover
            if isHovering {
                Button(action: {
                    dataManager.deleteMediaFromFolder(folder, media: mediaItem)
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.white)
                        .background(Circle().fill(Color.red.opacity(0.8)))
                        .font(.system(size: 20))
                }
                .buttonStyle(.plain)
                .padding(6)
            }
        }
        .onHover { hovering in
            isHovering = hovering
        }
        .onTapGesture {
            openMediaViewer()
        }
        .help("Click to view full size")
    }
    
    private func openMediaViewer() {
        guard let image = mediaItem.image else { return }
        
        let window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 600),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        window.title = "Image Gallery"
        window.center()
        window.contentView = NSHostingView(
            rootView: MediaViewerWindow(folder: folder, initialMediaItem: mediaItem)
                .environmentObject(DataManager.shared)
        )
        window.makeKeyAndOrderFront(nil)
        window.isReleasedWhenClosed = false
    }
}

// MARK: - Media Viewer Window

struct MediaViewerWindow: View {
    @EnvironmentObject var dataManager: DataManager
    let folder: DailyFolder
    let initialMediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss
    @State private var currentIndex: Int = 0
    
    private var currentFolder: DailyFolder {
        dataManager.dailyFolders.first(where: { $0.id == folder.id }) ?? folder
    }
    
    private var mediaItems: [MediaItem] {
        currentFolder.mediaItems
    }
    
    private var currentMediaItem: MediaItem? {
        guard currentIndex >= 0 && currentIndex < mediaItems.count else { return nil }
        return mediaItems[currentIndex]
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            if let image = currentMediaItem?.image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            // Navigation buttons
            HStack {
                // Previous button
                if currentIndex > 0 {
                    Button(action: {
                        withAnimation {
                            currentIndex -= 1
                        }
                    }) {
                        Image(systemName: "chevron.left.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.black.opacity(0.6))
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                    .buttonStyle(.plain)
                    .padding(.leading, 20)
                    .help("Previous image (Left arrow)")
                }
                
                Spacer()
                
                // Next button
                if currentIndex < mediaItems.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentIndex += 1
                        }
                    }) {
                        Image(systemName: "chevron.right.circle.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.black.opacity(0.6))
                            .background(Circle().fill(Color.white.opacity(0.8)))
                    }
                    .buttonStyle(.plain)
                    .padding(.trailing, 20)
                    .help("Next image (Right arrow)")
                }
            }
            
            // Close button and image counter
            VStack {
                HStack {
                    // Image counter
                    if mediaItems.count > 1 {
                        Text("\(currentIndex + 1) / \(mediaItems.count)")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.black.opacity(0.7))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.white.opacity(0.9))
                            .cornerRadius(12)
                            .padding(.leading, 20)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.black.opacity(0.6))
                    }
                    .buttonStyle(.plain)
                    .padding(20)
                }
                Spacer()
            }
        }
        .frame(minWidth: 400, minHeight: 400)
        .onAppear {
            // Find the initial index
            if let index = mediaItems.firstIndex(where: { $0.id == initialMediaItem.id }) {
                currentIndex = index
            }
            
            // Set up keyboard event monitoring
            NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
                switch event.keyCode {
                case 123: // Left arrow
                    if currentIndex > 0 {
                        withAnimation {
                            currentIndex -= 1
                        }
                        return nil
                    }
                case 124: // Right arrow
                    if currentIndex < mediaItems.count - 1 {
                        withAnimation {
                            currentIndex += 1
                        }
                        return nil
                    }
                case 53: // Escape
                    dismiss()
                    return nil
                default:
                    break
                }
                return event
            }
        }
    }
}

#Preview {
    FolderDetailView(folder: DailyFolder(name: "Today", date: Date(), notes: [
        Note(title: "Meeting Notes", content: "Discuss project timeline"),
        Note(title: "Ideas", content: "New feature concepts")
    ]))
    .environmentObject(DataManager.shared)
}
