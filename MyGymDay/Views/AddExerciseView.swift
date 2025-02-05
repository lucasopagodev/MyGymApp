//
//  AddExerciseView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//
import SwiftUI

struct AddExerciseView: View {
    var workout: Workout
    @EnvironmentObject var viewModel: GymViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) private var modelContext
    @Environment(\.colorScheme) var colorScheme
    
    @State private var exerciseName = ""
    @State private var repetitions = ""
    @State private var sets = 3
    @State private var restTime = 60
    @State private var observation = ""
    
    var exerciseToEdit: Exercise?
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    Text(exerciseToEdit == nil ? "Novo Exercício" : "Atualizar Exercício")
                        .font(.title2)
                        .bold()
                        .padding(.top, 20)
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Nome do Exercício")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("Ex: Supino Reto", text: $exerciseName)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))

                        Text("Repetições")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("Ex: 8-10 ou 12", text: $repetitions)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))
                        
                        Text("Séries")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $sets, in: 1...10) {
                            Text("\(sets) séries")
                                .font(.headline)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))
                        
                        Text("Descanso (segundos)")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Stepper(value: $restTime, in: 10...300, step: 10) {
                            Text("\(restTime) segundos")
                                .font(.headline)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))
                        
                        Text("Observação")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextEditor(text: $observation)
                            .frame(minHeight: 100)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))
                    }
                    .padding()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(UIColor.systemBackground))
                
                VStack(spacing: 12) {
                    Button(action: saveExercise) {
                        Text(exerciseToEdit == nil ? "Salvar" : "Atualizar")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(exerciseName.isEmpty || repetitions.isEmpty ? Color.gray : Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .shadow(radius: exerciseName.isEmpty || repetitions.isEmpty ? 0 : 5)
                    }
                    .disabled(exerciseName.isEmpty || repetitions.isEmpty)
                    
                    Button("Cancelar") {
                        dismiss()
                    }
                    .font(.headline)
                    .foregroundColor(.red)
                    .padding(.bottom, 20)
                }
                .padding()
                .background(Color(UIColor.systemBackground))
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(UIColor.systemBackground).ignoresSafeArea())
            .navigationTitle(exerciseToEdit == nil ? "Novo Exercício" : "Editar Exercício")
            .navigationBarHidden(true)
            .onAppear {
                if let exercise = exerciseToEdit {
                    exerciseName = exercise.name
                    repetitions = exercise.repetitions
                    sets = exercise.sets
                    restTime = exercise.restTime
                    observation = exercise.observation
                }
            }
        }
    }
    
    private func saveExercise() {
        if let exercise = exerciseToEdit {
            viewModel.editExercise(exercise, name: exerciseName, repetitions: repetitions, sets: sets, restTime: restTime, observation: observation, modelContext: modelContext)
        } else {
            viewModel.addExercise(to: workout, name: exerciseName, repetitions: repetitions, sets: sets, restTime: restTime, observation: observation, modelContext: modelContext)
        }
        dismiss()
    }
}

struct AddExerciseView_Previews: PreviewProvider {
    static var previews: some View {
        let workout = Workout(name: "Treino de Força")
        let view = AddExerciseView(workout: workout)
            .environmentObject(GymViewModel())
        return view
    }
}
