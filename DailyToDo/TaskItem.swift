//
//  TaskItem.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//

import Foundation

struct TaskItem: Identifiable, Codable {
    let id: UUID
    var title: String
    var isDone: Bool
    
    init(id: UUID = UUID(), title: String = "",
    isDone: Bool = false) {
        self.id = id
        self.title = title
        self.isDone = isDone
    }
}
