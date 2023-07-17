//
//  Goal.swift
//  MyPiggyWatch Watch App
//
//  Created by Noel Rosario on 7/17/23.
//

import Foundation

enum GoalType: String, Codable {
    case basic
    case custom
    case broken
}

struct Goal: Codable, Identifiable {
    let id: String
    let name: String
    let totalAmount: Double
    let goalType: GoalType
    let isBroken: Bool
}
