//
//  WorkoutDetailView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    @ObservedObject var viewModel: GymViewModel
    @State private var isAddingExercise = false

    var body: some View {
        List {
            ForEach(workout.exercises) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.name).font(.headline)
                    Text("Reps: \(exercise.repetitions), Sets: \(exercise.sets), Rest: \(exercise.restTime)s")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle(workout.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { isAddingExercise.toggle() }) {
                    Image(systemName: "plus")
                }
            }
        }
        .sheet(isPresented: $isAddingExercise) {
            AddExerciseView(workout: workout, viewModel: viewModel)
        }
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout(name: "Sample Workout")
        workout.exercises.append(Exercise(name: "Push-Ups", repetitions: "10-12", sets: 3, restTime: 60))
        return WorkoutDetailView(workout: workout, viewModel: GymViewModel())
    }
}
