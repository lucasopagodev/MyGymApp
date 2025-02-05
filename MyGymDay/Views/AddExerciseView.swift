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
    
    @State private var exerciseName = ""
    @State private var repetitions = ""
    @State private var sets = 3
    @State private var restTime = 60
    @State private var position = 1
    @State private var observation = ""
    
    var exerciseToEdit: Exercise?

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text(exerciseToEdit == nil ? "Novo Exercício" : "Editar Exercício")
                    .font(.title)
                    .bold()
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Nome do Exercício")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("Ex: Supino Reto", text: $exerciseName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                        .padding(.horizontal)

                    Text("Repetições")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("Ex: 8-10 ou 12", text: $repetitions)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
                        .padding(.horizontal)
                    
                    Text("Observação")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextEditor(text: $observation)
                        .frame(minHeight: 10) // Ajusta a altura mínima para um melhor uso
                        .padding(8) // Adiciona um espaçamento interno
                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6))) // Fundo semelhante ao TextField
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.3))) // Borda sutil
                        .padding(.horizontal)

//                    TextField("Carga 10kg", text: $observation)
//                        .textFieldStyle(RoundedBorderTextFieldStyle())
//                        .padding()
//                        .background(RoundedRectangle(cornerRadius: 12).fill(Color(.systemGray6)))
//                        .padding(.horizontal)

                    Stepper(value: $sets, in: 1...10) {
                        Text("Séries: \(sets)")
                            .font(.headline)
                    }
                    .padding(.horizontal)

                    Stepper(value: $restTime, in: 10...300, step: 10) {
                        Text("Descanso: \(restTime) segundos")
                            .font(.headline)
                    }
                    .padding(.horizontal)
                }
                .padding(.horizontal)

                Spacer()

                Button(action: saveExercise) {
                    Text(exerciseToEdit == nil ? "Salvar" : "Atualizar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(exerciseName.isEmpty || repetitions.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
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
            .padding(.bottom, safeAreaBottomInset)
            .background(Color(.systemBackground))
            .edgesIgnoringSafeArea(.bottom)
            .onTapGesture {
                hideKeyboard()
            }
            .navigationBarHidden(true)
            .onAppear {
                // Preenche os campos se estiver editando um exercício
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

    public var safeAreaBottomInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.bottom
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
        workout.exercises.append(Exercise(name: "Supino", repetitions: "8-10", sets: 4, restTime: 60, observation: "Carga 10kg", position: 1))

        let addExerciseView = AddExerciseView(workout: workout)
            .environmentObject(GymViewModel())

        let editExerciseView = AddExerciseView(workout: workout, exerciseToEdit: workout.exercises.first)
            .environmentObject(GymViewModel())

        return Group {
            addExerciseView
            editExerciseView
        }
    }
}
