//
//  Workout.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftData
import Foundation

@Model
class Workout {
    var id: UUID
    var name: String
    var exercises: [Exercise]

    init(name: String) {
        self.id = UUID()
        self.name = name
        self.exercises = []
    }
}
