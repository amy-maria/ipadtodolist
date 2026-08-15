//
//  Field.swift
//  DailyToDo
//
//  Created by Amy Rowell on 8/12/26.
//
import Foundation

enum Field: Hashable {
    case main(Int)
    case priority(Int)
    case tomorrow(Int)
    case notes
}
