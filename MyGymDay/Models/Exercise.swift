//
//  Exercise.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftData
import Foundation

@Model
class Exercise: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var repetitions: String // e.g., "8-10" or "12"
    var sets: Int
    var restTime: Int // in seconds

    init(name: String, repetitions: String, sets: Int, restTime: Int) {
        self.id = UUID()
        self.name = name
        self.repetitions = repetitions
        self.sets = sets
        self.restTime = restTime
    }
}
