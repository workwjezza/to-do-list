//
//  Note.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var content: String
    var createdAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id, title, content, createdAt
    }
}
