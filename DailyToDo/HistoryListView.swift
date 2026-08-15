//
//  HistoryListView.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/14/26.
//
import SwiftUI

struct HistoryListView: View {
    let history: [DayPlan]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            List(history, id: \.date) { day in NavigationLink {
                HistoryDayView(dayPlan: day)
            } label: {
                Text(day.date.formatted(date: .long, time: .omitted))
            }
            }
            .overlay {
                if history.isEmpty {
                    ContentUnavailableView("No Saved Days", systemImage: "clock.arrow.circlepath")
                }
            }
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {dismiss() }
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
#Preview {
    HistoryListView(history: [.blank()])
    
    
}
