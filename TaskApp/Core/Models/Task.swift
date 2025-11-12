//
//  Task.swift
//  TaskApp
//
//  Created by Francisco José García García on 15/10/25.
//
import Foundation
import SwiftData

@Model
class Task: Identifiable, Codable {

    private enum CodingKeys: CodingKey {
        case id, title, isCompleted, priority, reminderDate
    }

    let id: UUID
    var title: String
    var isCompleted: Bool = false
    var priority: Priority?
    var reminderDate: Date?
    
    init(title: String, isCompleted: Bool = false, dueDate: Date? = nil, priority: Priority? = nil, reminderDate: Date? = nil) {
        self.id = UUID()
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.reminderDate = reminderDate
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        isCompleted = try container.decode(Bool.self, forKey: .isCompleted)
        priority = try container.decodeIfPresent(Priority.self, forKey: .priority)
        reminderDate = try container.decodeIfPresent(Date.self, forKey: .reminderDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(isCompleted, forKey: .isCompleted)
        try container.encodeIfPresent(priority, forKey: .priority)
        try container.encodeIfPresent(reminderDate, forKey: .reminderDate)
    }
}


enum Priority: String, Codable {
    case low, medium, high
}
