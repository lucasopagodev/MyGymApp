//
//  GymViewModel.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI
import SwiftData

class GymViewModel: ObservableObject {
    @Published var workouts: [Workout] = []

    func addWorkout(name: String) {
        let workout = Workout(name: name)
        workouts.append(workout)
    }

    func deleteWorkout(_ workout: Workout) {
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
    }

    func addExercise(to workout: Workout, name: String, repetitions: String, sets: Int, restTime: Int) {
        let exercise = Exercise(name: name, repetitions: repetitions, sets: sets, restTime: restTime)
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts[index].exercises.append(exercise)
        }
    }
}
