//
//  MediaItem.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation
import AppKit

struct MediaItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var imageData: Data
    var dateAdded: Date
    var originalFileName: String?
    
    enum CodingKeys: String, CodingKey {
        case id, imageData, dateAdded, originalFileName
    }
    
    // Helper to get NSImage from data
    var image: NSImage? {
        return NSImage(data: imageData)
    }
}
