//
//  TodoItem.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation

struct TodoItem: Identifiable, Codable, Equatable {
    var id = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdAt: Date = Date()
    
    enum CodingKeys: String, CodingKey {
        case id, title, isCompleted, createdAt
    }
}
