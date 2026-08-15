//
//  DayPlan.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//

import Foundation

struct DayPlan: Codable {
    var date: Date
    var mainTasks: [TaskItem]
    var topPriorities: [TaskItem]
    var tomorrowTasks: [TaskItem]
    var notes: String
    var pageDrawing: Data
    var sectionFrames: [String: CGRect] = [:]
    
    static func blank(date: Date = Date()) -> DayPlan {
        DayPlan(
            date: date,
            mainTasks: (1...20).map { _ in TaskItem() },
            topPriorities: (1...4).map { _ in TaskItem() },
            tomorrowTasks: (1...7).map { _ in TaskItem() },
            notes: "",
            pageDrawing: Data()
        )
    }
}
