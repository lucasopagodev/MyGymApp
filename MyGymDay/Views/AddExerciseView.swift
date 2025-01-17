//
//  AddExerciseView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI
import SwiftData

struct AddExerciseView: View {
    var workout: Workout
    @ObservedObject var viewModel: GymViewModel
    @Environment(\ .dismiss) var dismiss
    @State private var exerciseName = ""
    @State private var repetitions = ""
    @State private var sets = 1
    @State private var restTime = 30

    var body: some View {
        NavigationView {
            Form {
                TextField("Exercise Name", text: $exerciseName)
                TextField("Repetitions (e.g., 8-10 or 12)", text: $repetitions)
                Stepper("Sets: \(sets)", value: $sets, in: 1...10)
                Stepper("Rest Time: \(restTime) seconds", value: $restTime, in: 10...300, step: 10)
            }
            .navigationTitle("Add Exercise")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addExercise(to: workout, name: exerciseName, repetitions: repetitions, sets: sets, restTime: restTime)
                        dismiss()
                    }
                    .disabled(exerciseName.isEmpty || repetitions.isEmpty)
                }
            }
        }
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout(name: "Sample Workout")
        return AddExerciseView(workout: workout, viewModel: GymViewModel())
    }
}
