//
//  ContentView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GymViewModel()
    @State private var isAddingWorkout = false

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.workouts) { workout in
                    NavigationLink(destination: WorkoutDetailView(workout: workout, viewModel: viewModel)) {
                        Text(workout.name)
                    }
                }
                .onDelete { indexSet in
                    indexSet.map { viewModel.workouts[$0] }.forEach(viewModel.deleteWorkout)
                }
            }
            .navigationTitle("Workouts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { isAddingWorkout.toggle() }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $isAddingWorkout) {
                AddWorkoutView(viewModel: viewModel)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
