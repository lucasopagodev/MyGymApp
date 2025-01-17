//
//  AddWorkoutView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//
import SwiftUI
import SwiftData

struct AddWorkoutView: View {
    @Environment(\ .dismiss) var dismiss
    @ObservedObject var viewModel: GymViewModel
    @State private var workoutName = ""

    var body: some View {
        NavigationView {
            Form {
                TextField("Workout Name", text: $workoutName)
            }
            .navigationTitle("Add Workout")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addWorkout(name: workoutName)
                        dismiss()
                    }
                    .disabled(workoutName.isEmpty)
                }
            }
        }
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView(viewModel: GymViewModel())
    }
}
