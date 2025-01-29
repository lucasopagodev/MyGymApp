//
//  WorkoutDetailView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    var workout: Workout
    @EnvironmentObject var viewModel: GymViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingExercise = false
    @State private var selectedExercise: Exercise?

    var body: some View {
        VStack {
            if workout.exercises.isEmpty {
                // Mensagem quando não há exercícios
                VStack {
                    Image(systemName: "square.grid.2x2.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundColor(.gray.opacity(0.5))

                    Text("Nenhum exercício cadastrado")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top, 8)

                    Text("Toque no botão abaixo para adicionar um exercício.")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding()
                .frame(maxHeight: .infinity, alignment: .center)  // Centraliza a mensagem
            } else {
                // Lista de exercícios
                List {
                    ForEach(workout.exercises) { exercise in
                        HStack {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                
                                Text("Reps: \(exercise.repetitions), Sets: \(exercise.sets), Rest: \(exercise.restTime)s")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            
                            Spacer()
                        }
                        .padding()
                    }
                    .onDelete { indexSet in
                        indexSet.forEach { index in
                            let exerciseToDelete = workout.exercises[index]
                            viewModel.deleteExercise(exerciseToDelete, modelContext: modelContext)
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(workout.name)
        .safeAreaInset(edge: .bottom) {
            // Botão flutuante para adicionar exercício
            HStack {
                HStack {
                    Spacer()
                    Button(action: { isAddingExercise.toggle() }) {
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .padding()
                            .background(Circle().fill(Color.green))
                            .foregroundColor(.white)
                            .shadow(radius: 5)
                    }
                    .padding()
                }
            }
        }
        .sheet(isPresented: $isAddingExercise) {
            AddExerciseView(workout: workout)
        }
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout(name: "Sample Workout")
        workout.exercises.append(Exercise(name: "Push-Ups", repetitions: "10-12", sets: 3, restTime: 60))
        return WorkoutDetailView(workout: workout)
            .environmentObject(GymViewModel())
            .modelContainer(for: [Workout.self, Exercise.self])
    }
}
