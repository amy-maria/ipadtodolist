//
//  SectionFramePreferenceKey.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/14/26.
//

import SwiftUI

struct SectionFramePreferenceKey: PreferenceKey {
    static var defaultValue: [String: CGRect] = [:]
    
    static func reduce(value: inout [String: CGRect], nextValue: () -> [String: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: {$1})
    }
    
}

extension View {
    func trackSectionFrame(_ label: String) -> some View {
        self.background(
            GeometryReader {
                geo in
                Color.clear.preference(
                                        key: SectionFramePreferenceKey.self,
                                       value: [label: geo.frame(in: .named("page"))]
                )
            }
        )
    }
}
