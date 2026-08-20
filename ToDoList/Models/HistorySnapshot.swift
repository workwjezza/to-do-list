//
//  HistorySnapshot.swift
//  ToDoList
//
//  Created on 8/20/2026.
//

import Foundation

struct HistorySnapshot: Identifiable, Codable {
    var id = UUID()
    var date: Date
    var todoItems: [TodoItem]
    var dailyFolders: [DailyFolder]
    
    var displayDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, date, todoItems, dailyFolders
    }
}
