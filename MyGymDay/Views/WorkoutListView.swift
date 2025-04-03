//
//  WorkoutListView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 26/02/25.
//

import SwiftUI

struct WorkoutListView: View {
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
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    // Botão de exclusão
                                    Button(role: .destructive) {
                                        viewModel.deleteWorkout(workout, modelContext: modelContext)
                                    } label: {
                                        Label("Excluir", systemImage: "trash")
                                    }

                                }
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


struct WorkoutListView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutListView().environmentObject(GymViewModel())
    }
}
