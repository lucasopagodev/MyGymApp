//
//  AddWorkoutView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//
import SwiftUI

struct AddWorkoutView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: GymViewModel
    @Environment(\.modelContext) private var modelContext
    @State private var workoutName = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Novo Treino")
                    .font(.title2)
                    .bold()
                    .padding(.top, 20)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Nome do Treino")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    TextField("Ex: Treino de Pernas", text: $workoutName)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color(UIColor.systemBackground)))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.green.opacity(0.3)))
                        .submitLabel(.done)
                        .onSubmit {
                            if !workoutName.isEmpty {
                                saveWorkout()
                            }
                        }
                }
                .padding(.horizontal)

                Spacer()

                Button(action: saveWorkout) {
                    Text("Salvar")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(workoutName.isEmpty ? Color.gray : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .shadow(radius: workoutName.isEmpty ? 0 : 5)
                }
                .disabled(workoutName.isEmpty)

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
            .navigationBarHidden(true) // Esconde a barra de navegação padrão
        }
    }
    
    public var safeAreaBottomInset: CGFloat {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            return 0
        }
        return window.safeAreaInsets.bottom
    }

    private func saveWorkout() {
        viewModel.addWorkout(name: workoutName, modelContext: modelContext)
        dismiss()
    }
}

struct AddWorkoutView_Previews: PreviewProvider {
    static var previews: some View {
        AddWorkoutView()
            .environmentObject(GymViewModel())
            .modelContainer(for: [Workout.self, Exercise.self])
    }
}
