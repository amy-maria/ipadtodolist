//
//  HistoryDayView.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/14/26.
//

import SwiftUI
import PencilKit

struct HistoryDayView: View {
    let dayPlan: DayPlan
    
    private let dayLetters = ["M", "T", "W", "R", "S", "S"]
    private let sectionOrder = ["Main List", "Top Priority", "For Tomorrow", "Notes"]
    
    //private var inkImage: Image? {
        //guard !dayPlan.pageDrawing.isEmpty,
             // let drawing = try? PKDrawing(data: dayPlan.pageDrawing),
              //!drawing.bounds.isEmpty else { return nil}
      //  let uiImage = drawing.image(from: drawing.bounds, scale: UIScreen.main.scale)
        //return Image(uiImage: uiImage)
    //}
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(dayPlan.date.formatted(date: .long, time: .omitted))
                    .font(.title2.bold())
                section(title:"TODAY") {
                    ForEach(dayPlan.mainTasks.filter {
                        !$0.title.isEmpty
                    }) {
                        task in readOnlyRow(task)
                    }
                }
                section(title: "TOP PRIORITIES") {
                    ForEach(dayPlan.topPriorities.filter {
                        !$0.title.isEmpty
                    }) {task in Text(task.title)
                    }
                }
                section(title: "FOR TOMORROW") {
                    ForEach(dayPlan.tomorrowTasks.filter {
                        !$0.title.isEmpty
                    }) { task in
                        readOnlyRow(task)
                    }
                }
                
                if !dayPlan.notes.isEmpty {
                    section(title: "NOTES") {
                        Text(dayPlan.notes)
                    }
                }
                ForEach(groupedInkImages(), id: \.label) { group
                    in
                    section(title: "HANDWRITTEN - \(group.label.uppercased())") {
                        group.image
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 250)
                            .background(Color(red: 0.05, green: 0.05, blue: 0.07))
                
                        
                .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
        }
        .preferredColorScheme(.dark)
        .navigationTitle("Previous Day")
    }
    private func readOnlyRow(_ task: TaskItem) -> some View {
        HStack(spacing: 10) {
            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(task.isDone ? .green : .secondary)
            Text(task.title)
                .strikethrough(task.isDone)
                .foregroundStyle(task.isDone ? .secondary : .primary)
        }
    }
    private func section<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.headline)
            content()
        }
        .padding(12)
        .background(Color.white.opacity(0.06))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private func groupedInkImages() -> [(label: String, image: Image)] {
        guard let drawing = try? PKDrawing(data: dayPlan.pageDrawing) else { return [] }
        var grouped: [String: [PKStroke]] = [:]
       
        
        for stroke in drawing.strokes {
            let center = CGPoint(x: stroke.renderBounds.midX, y: stroke.renderBounds.midY)
            if let match = dayPlan.sectionFrames.first(where: {
                
                $0.value.contains(center)
            }) {
                grouped[match.key, default: []].append(stroke)
            }
        }
        var results: [(label: String, image: Image)] = []
        for label in sectionOrder {
            if let strokes = grouped[label], !strokes.isEmpty {
                let subDrawing = PKDrawing(strokes: strokes)
                let uiImage = subDrawing.image(from: subDrawing.bounds, scale: UIScreen.main.scale)
                results.append((label, Image(uiImage: uiImage)))
            }
        }
        
        return results
    }
}

#Preview {
    NavigationStack {
        HistoryDayView(dayPlan: .blank())
    }
}
