//
//  GymViewModel.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//
import SwiftUI
import SwiftData

class GymViewModel: ObservableObject {
    @Published var workouts: [Workout] = []
    @Published var workoutLogs: [WorkoutLog] = []

    // Carrega todos os Workouts
    func loadWorkouts(modelContext: ModelContext) {
        do {
            workouts = try modelContext.fetch(FetchDescriptor<Workout>())
        } catch {
            print("Erro ao carregar Workouts: \(error)")
        }
    }

    // Adiciona um novo Workout
    func addWorkout(name: String, modelContext: ModelContext) {
        let workout = Workout(name: name)
        modelContext.insert(workout)
        saveContext(modelContext: modelContext)
        workouts.append(workout)
    }

    // Remove um Workout
    func deleteWorkout(_ workout: Workout, modelContext: ModelContext) {
        modelContext.delete(workout)
        saveContext(modelContext: modelContext)
        
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
    }
    
    // Adiciona um Exercise a um Workout
    func addExercise(to workout: Workout, name: String, repetitions: String, sets: Int, restTime: Int, observation: String, modelContext: ModelContext) {
        let position = workout.exercises.count
        let exercise = Exercise(name: name, repetitions: repetitions, sets: sets, restTime: restTime, observation: observation, position: position)
        workout.exercises.append(exercise)
        saveContext(modelContext: modelContext) // Salva o contexto após adicionar o exercício
    }

    // Remove um Exercise
    func deleteExercise(_ exercise: Exercise, modelContext: ModelContext) {
        modelContext.delete(exercise)
        saveContext(modelContext: modelContext)
        
        // Remove o exercício da lista do Workout
        if let workout = workouts.first(where: { $0.exercises.contains(where: { $0.id == exercise.id }) }) {
            if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
                workout.exercises.remove(at: index)
            }
        }
    }
    
    func registerWorkout(workout: Workout, modelContext: ModelContext) {
        let workoutLog = WorkoutLog(date: Date(), workout: workout)
        workoutLogs.append(workoutLog)
        modelContext.insert(workoutLog)
    }
    
    func hasWorkout(on date: Date) -> Bool {
        return workoutLogs.contains { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    // Edita um Exercise
    func editExercise(_ exercise: Exercise, name: String, repetitions: String, sets: Int, restTime: Int, observation: String, modelContext: ModelContext) {
        exercise.name = name
        exercise.repetitions = repetitions
        exercise.sets = sets
        exercise.restTime = restTime
        exercise.observation = observation
        saveContext(modelContext: modelContext) // Salva o contexto após editar o exercício
    }
    
    func moveExercise(in workout: Workout, from source: IndexSet, to destination: Int, modelContext: ModelContext) {
        workout.exercises.move(fromOffsets: source, toOffset: destination)
        updateExerciseOrder(for: workout)
        saveContext(modelContext: modelContext)
    }

    // Atualiza a propriedade `position` com base na nova ordem
    private func updateExerciseOrder(for workout: Workout) {
        for (index, exercise) in workout.exercises.enumerated() {
            exercise.position = index
        }
    }

    public func toggleExerciseCompletion(exercise: Exercise, modelContext: ModelContext) {
        exercise.isCompleted.toggle()
        saveContext(modelContext: modelContext)
    }
    
    // Salva o contexto do ModelContext
    private func saveContext(modelContext: ModelContext) {
        do {
            try modelContext.save()
        } catch {
            print("Erro ao salvar contexto: \(error)")
        }
    }
}
