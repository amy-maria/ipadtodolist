//
//  ContentView.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//

import SwiftUI

struct ContentView: View {
    @Bindable var store:DayStore
    @FocusState private var focusedField: Field?
    @State private var isDrawMode = false
    @State private var showNewDayConfirmation = false
    @State private var showHistory = false
    
    
    private let dayLetters = ["M", "T", "W", "R", "F", "S", "S"]
    
    
    var body: some View {
        VStack(spacing: 0) {
            Text("TODAY")
                .font(.largeTitle.bold())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(red: 0.33, green: 0.2, blue: 0.48))
                .overlay(alignment: .trailing) {
                    HStack(spacing: 16) {
                        Button {
                            showHistory = true
                        } label: {
                            Image(systemName: "clock.arrow.circlepath")
                                .font(.title2)
                                .foregroundStyle(.white)
                            
                        }
                        Button {
                            showNewDayConfirmation = true
                        } label: {
                            Image(systemName: "arrow.triangle.2.circlepath")
                                .font(.title2)
                                .foregroundStyle(.white)
                        }
                        Button {
                            isDrawMode.toggle()
                        } label: {
                            Image(systemName: isDrawMode ? "pencil.circle.fill" : "keyboard")
                                .font(.title2)
                                .foregroundStyle(.white)
                            
                        }
                    }
                    .padding(.trailing, 20)
                }
            
            ZStack {
                HStack(alignment: .top, spacing:24) {
                    mainListSection
                        .trackSectionFrame("Main List")
                    rightColumn
                }
                .padding()
                
                PencilOverlayView(drawingData: $store.dayPlan.pageDrawing, isDrawMode: isDrawMode)
                  
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .coordinateSpace(name: "page")
            .onPreferenceChange(SectionFramePreferenceKey.self)
            { frames in
                store.dayPlan.sectionFrames = frames
            }
           
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.12))
        .ignoresSafeArea(edges: .bottom)
        .preferredColorScheme(.dark)
        .alert("Start a New Day?", isPresented: $showNewDayConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Start New Day", role: .destructive) {
                DispatchQueue.main.async {
                    focusedField = nil
                    store.startNewDay()
                }
            }
        } message: {
            Text("Today's list will be saved to History and a fresh page will begin.")
        }
        .sheet(isPresented: $showHistory){
            HistoryListView(history: store.history)
        }
    }
    
    private var mainListSection: some View {
            VStack(spacing: 0) {
                ForEach(store.dayPlan.mainTasks.indices, id: \.self) { index in
                TaskRowView(
                    task: $store.dayPlan.mainTasks[index],
                    fieldID: .main(index),
                    focusedField: $focusedField,
                    onSubmit: { focusNext(after: .main(index)) }
                    )
            }
         }
            .frame(maxWidth: .infinity)
    }

    private var rightColumn: some View {
        VStack(alignment: .leading, spacing: 16) {
            dateRow
            topPrioritiesSection
                .trackSectionFrame("Top Priorities")
            forTomorrowSection
                .trackSectionFrame("For Tomorrow")
            notesSection
                .trackSectionFrame("Notes")
        }
        .frame(width: 320)
    }
    
    private var dateRow: some View {
            HStack {
                Text("DATE").font(.caption.bold())
                Spacer()
                HStack(spacing: 10) {
                    ForEach(dayLetters.indices, id: \.self) { i in Text(dayLetters[i]).font(.title2.bold())
                    }
                }
            }
            .padding(10)
            .background(Color.pink.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 6))
        }
        
        private var topPrioritiesSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("TOP PRIORITIES").font(.headline)
                ForEach(store.dayPlan.topPriorities.indices, id: \.self) { index in
                    TextField("", text: $store.dayPlan.topPriorities[index].title)
                        .submitLabel(.next)
                        .focused($focusedField, equals: .priority(index))
                        .onSubmit { focusNext(after: .priority(index))
                        }
                        .padding(8)
                        .background(Color.mint.opacity(0.18))
                        .clipShape(RoundedRectangle(cornerRadius: 6))
                }
            }
        }
        
        private var forTomorrowSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("FOR TOMORROW").font(.headline)
                ForEach(store.dayPlan.tomorrowTasks.indices, id: \.self) { index in
                    TaskRowView(
                        task: $store.dayPlan.tomorrowTasks[index],
                        fieldID: .tomorrow(index),
                        focusedField: $focusedField,
                        onSubmit: { focusNext(after: .tomorrow(index))
                    }
                    )
                }
            }
            .padding(12)
            .background(Color.indigo.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
        private var notesSection: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text("NOTES").font(.headline)
                TextEditor(text: $store.dayPlan.notes)
                    .frame(minHeight: 150)
                    .scrollContentBackground(.hidden)
                    .focused($focusedField, equals: .notes)
            }
            .padding(12)
            .background(Color.mint.opacity(0.15))
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    private func focusNext(after field: Field) {
  
        switch field {
        case .main(let i):
            let next = i+1
            focusedField = next < store.dayPlan.mainTasks.count ? .main(next) : .priority(0)
        case .priority(let i):
            let next = i + 1
            focusedField = next < store.dayPlan.topPriorities.count ? .priority(next) : .tomorrow(0)
        case .tomorrow(let i):
            let next = i + 1
            focusedField = next < store.dayPlan.tomorrowTasks.count ? .tomorrow(next) : .notes
        case .notes:
            focusedField = nil
        }
        }
    }
#Preview {
    ContentView(store: DayStore())
}
