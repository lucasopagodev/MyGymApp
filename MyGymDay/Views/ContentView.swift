//
//  ContentView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: GymViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var isAddingWorkout = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.workouts.isEmpty {
                    VStack {
                        Image(systemName: "dumbbell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.gray.opacity(0.5))
                        
                        Text("Nenhum treino cadastrado")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .padding(.top, 8)
                        
                        Text("Toque no botão + para adicionar um novo treino.")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                    .padding()
                } else {
                    List {
                        ForEach(viewModel.workouts) { workout in
                            NavigationLink(destination: WorkoutDetailView(workout: workout)) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 5) {
                                        Text(workout.name)
                                            .font(.headline)
                                            .foregroundColor(.primary)
                                        
                                        Text("\(workout.exercises.count) exercícios")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                    
                                    Spacer()
                                }
                                .padding()
                            }
                            .padding(.vertical, 5)
                        }
                        .onDelete { indexSet in
                            indexSet.map { viewModel.workouts[$0] }.forEach {
                                viewModel.deleteWorkout($0, modelContext: modelContext)
                            }
                        }
                    }
                    .listStyle(PlainListStyle())
                }
            }
            .navigationTitle("Meus Treinos")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
            .safeAreaInset(edge: .bottom) {  // Garante que o botão esteja acima da área segura
                // Botão flutuante para adicionar exercício
                HStack {
                    HStack {
                        Spacer()
                        Button(action: { isAddingWorkout.toggle() }) {
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
            .sheet(isPresented: $isAddingWorkout) {
                AddWorkoutView()
            }
            .onAppear {
                viewModel.loadWorkouts(modelContext: modelContext)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GymViewModel()
        
        // Adiciona um treino de exemplo para o preview
        let sampleWorkout = Workout(name: "Treino Superior")
        sampleWorkout.exercises.append(Exercise(name: "Supino Reto", repetitions: "10-12", sets: 3, restTime: 60, observation: "Carga 12kg", position: 1))
        sampleWorkout.exercises.append(Exercise(name: "Rosca Direta", repetitions: "12-15", sets: 3, restTime: 45, observation: "Carga 12kg", position: 2))

        viewModel.workouts.append(sampleWorkout)

        return ContentView()
            .environmentObject(viewModel)
            .modelContainer(for: [Workout.self, Exercise.self])
    }
}
