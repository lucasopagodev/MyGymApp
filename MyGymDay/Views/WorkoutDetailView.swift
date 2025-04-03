//
//  WorkoutDetailView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct WorkoutDetailView: View {
    @ObservedObject var workout: Workout
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
                    ForEach(workout.exercises.sorted { $0.position < $1.position }) { exercise in
                        HStack {
                            // Botão para marcar/desmarcar como feito
                            Button(action: {
                                viewModel.toggleExerciseCompletion(exercise: exercise, modelContext: modelContext)
                            }) {
                                Image(systemName: exercise.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(exercise.isCompleted ? .green : .gray)
                                    .font(.system(size: 24))
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text(exercise.name)
                                    .font(.headline)
                                    .foregroundColor(.primary)
                                    .strikethrough(exercise.isCompleted)
                                
                                Text("Reps: \(exercise.repetitions), Sets: \(exercise.sets), Rest: \(exercise.restTime)s")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                                    .strikethrough(exercise.isCompleted)
                                
                                Text("Obs: \(exercise.observation)")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                    .strikethrough(exercise.isCompleted)
                            }
                            
                            Spacer()
                        }
                        .padding()
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            // Botão de exclusão
                            Button(role: .destructive) {
                                viewModel.deleteExercise(exercise, modelContext: modelContext)
                            } label: {
                                Label("Excluir", systemImage: "trash")
                            }

                            // Botão de edição
                            Button {
                                selectedExercise = exercise // Seleciona o exercício para edição
                                isAddingExercise = true // Abre a tela de edição
                            } label: {
                                Label("Editar", systemImage: "pencil")
                            }
                            .tint(.green)
                        }
                    }
                    .onMove { indexSet, destination in
                        viewModel.moveExercise(in: workout, from: indexSet, to: destination, modelContext: modelContext)
                    }
                }
                .listStyle(PlainListStyle())
            }
        }
        .navigationTitle(workout.name)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                EditButton() // Botão de edição para ativar o modo de arrastar
            }
        }
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
            AddExerciseView(workout: workout, exerciseToEdit: selectedExercise)
            .onDisappear {
                selectedExercise = nil // Limpa o exercício selecionado ao fechar a tela
            }
        }
        // Botão para registrar o treino
        Button(action: {
            viewModel.registerWorkout(workout: workout, modelContext: modelContext)
        }) {
            Text("Registrar Treino")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
        }
        .padding()
    }
}

struct WorkoutDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout(name: "Sample Workout")
        workout.exercises.append(Exercise(name: "Push-Ups", repetitions: "10-12", sets: 3, restTime: 60, observation: "12kg de carga", position: 1))
        workout.exercises.append(Exercise(name: "Push-Ups 2", repetitions: "8-12", sets: 4, restTime: 60, observation: "12kg de carga", position: 2))
        return WorkoutDetailView(workout: workout)
            .environmentObject(GymViewModel())
            .modelContainer(for: [Workout.self, Exercise.self])
    }
}
