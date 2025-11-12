import SwiftData
import Foundation

@Model
class TaskDueDate: Codable {
    let id: UUID
    var taskUid: UUID
    var dueDate: Date?

    init(taskUid: UUID, dueDate: Date?) {
        self.id = UUID()
        self.taskUid = taskUid
        self.dueDate = dueDate
    }

    private enum CodingKeys: CodingKey {
        case id
        case taskUid
        case dueDate
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        taskUid = try container.decode(UUID.self, forKey: .taskUid)
        dueDate = try container.decodeIfPresent(Date.self, forKey: .dueDate)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(taskUid, forKey: .taskUid)
        try container.encodeIfPresent(dueDate, forKey: .dueDate)
    }
}
