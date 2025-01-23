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
    @Published var exercises: [Exercise] = []

    func loadWorkouts(modelContext: ModelContext) {
        do {
            workouts = try modelContext.fetch(FetchDescriptor<Workout>())
        } catch {
            print("Erro loading Workouts: \(error)")
        }
    }

    func addWorkout(name: String, modelContext: ModelContext) {
        let workout = Workout(name: name)
        modelContext.insert(workout)
        saveContext(modelContext: modelContext)
        workouts.append(workout)
    }

    func deleteWorkout(_ workout: Workout, modelContext: ModelContext) {
        modelContext.delete(workout)
        saveContext(modelContext: modelContext)
        
        if let index = workouts.firstIndex(where: { $0.id == workout.id }) {
            workouts.remove(at: index)
        }
    }
    
    func addExercise(to workout: Workout, name: String, repetitions: String, sets: Int, restTime: Int, modelContext: ModelContext) {
        let exercise = Exercise(name: name, repetitions: repetitions, sets: sets, restTime: restTime)
        workout.exercises.append(exercise)
        saveContext(modelContext: modelContext)
    }

    func deleteExercise(_ exercise: Exercise, modelContext: ModelContext) {
        modelContext.delete(exercise)
        saveContext(modelContext: modelContext)
        
        // Removendo o exercício da lista do workout
        if let workout = workouts.first(where: { $0.exercises.contains(where: { $0.id == exercise.id }) }) {
            if let index = workout.exercises.firstIndex(where: { $0.id == exercise.id }) {
                workout.exercises.remove(at: index)
            }
        }
    }
    
    func editExercise(_ exercise: Exercise, name: String, repetitions: String, sets: Int, restTime: Int, modelContext: ModelContext) {
        // Atualiza os dados do exercício
        exercise.name = name
        exercise.repetitions = repetitions
        exercise.sets = sets
        exercise.restTime = restTime
        
        // Salva as mudanças no contexto
        saveContext(modelContext: modelContext)
    }

    private func saveContext(modelContext: ModelContext) {
        do {
            try modelContext.save()
        } catch {
            print("Error saving: \(error)")
        }
    }
}
