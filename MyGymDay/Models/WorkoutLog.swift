//
//  WorkoutLog.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 26/02/25.
//

import SwiftData
import Foundation

@Model
class WorkoutLog: Identifiable, ObservableObject {
    @Attribute(.unique) var id: UUID
    var date: Date
    var workout: Workout?

    init(date: Date, workout: Workout?) {
        self.id = UUID()
        self.date = date
        self.workout = workout
    }
}
