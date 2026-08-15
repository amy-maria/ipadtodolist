//
//  DailyToDoApp.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//

import SwiftUI

@main
struct DailyToDoApp: App {
    @State private var store = DayStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView(store: store)
        }
    }
}
