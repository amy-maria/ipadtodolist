//
//  TaskRowView.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//
import SwiftUI

struct TaskRowView: View {
    @Binding var task: TaskItem
    var fieldID: Field
    var focusedField: FocusState<Field?>.Binding
    var onSubmit: () -> Void = {}
    
    var body: some View {
        HStack(spacing: 10) {
            Button{
                task.isDone.toggle()
            } label: {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(task.isDone ? .green : .secondary)
            }
            .buttonStyle(.plain)
            
            TextField("", text: $task.title)
                .textFieldStyle(.plain)
                .strikethrough(task.isDone)
                .foregroundStyle(task.isDone ? .secondary : .primary)
                .submitLabel(.next)
                .focused(focusedField, equals: fieldID)
                .onSubmit(onSubmit)
                .overlay(alignment: .bottom) {
                    DashedLine()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 3]))
                        .foregroundStyle(.secondary.opacity(0.9))
                        .frame(height: 1)
                }
        }
        .padding(.vertical, 14)
    }
}
private struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.width, y: rect.midY))
        return path
    }
}

