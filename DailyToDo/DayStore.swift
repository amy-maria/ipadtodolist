//
//  DayStore.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//

import Foundation

@Observable
final class DayStore {
    var dayPlan: DayPlan {
        didSet { save() }
    }
    private(set) var history: [DayPlan] = []
    private let retentionDays = 7
    
    private let fileURL: URL = {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent("dayPlan.json")}()
    
    init() {
        if let data = try? Data(contentsOf: fileURL),
           let saved = try? JSONDecoder().decode(StoredData.self, from: data) {
            dayPlan = saved.current
            history = saved.history
        } else {
            dayPlan = .blank()
        }
        pruneHistory()
    }
    func startNewDay() {
        
        history.insert(dayPlan, at: 0)
        pruneHistory()
        dayPlan = .blank()
    }
    private func pruneHistory() {
        let cutoff = Calendar.current.date(byAdding: .day, value: -retentionDays, to: Date()) ?? Date()
        history.removeAll { $0.date < cutoff }
    }
    
    private func save() {
        let stored = StoredData(current: dayPlan, history: history)
        guard let data = try? JSONEncoder().encode(stored) else {
            return
        }
        try? data.write(to: fileURL, options: .atomic)
    }
    
}
private struct StoredData: Codable {
    var current: DayPlan
    var history: [DayPlan]
}
