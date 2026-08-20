//
//  DailyFolder.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation

struct DailyFolder: Identifiable, Codable, Equatable {
    var id = UUID()
    var name: String
    var date: Date
    var notes: [Note] = []
    var mediaItems: [MediaItem] = []
    
    var displayName: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return name.isEmpty ? formatter.string(from: date) : name
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, date, notes, mediaItems
    }
}
