//
//  ContentView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            WorkoutListView()
                .tabItem {
                    Image(systemName: "dumbbell.fill")
                    Text("Meus Treinos")
                }

            CalendarView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Calendário de Treinos")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = GymViewModel()
        
        // Criando treino de exemplo
        let sampleWorkout = Workout(name: "Treino Superior")
        viewModel.workouts.append(sampleWorkout)

        return ContentView()
            .environmentObject(viewModel) // 🔥 Adicionando o ambiente corretamente
            .modelContainer(for: [Workout.self, Exercise.self]) // Somente se necessário
    }
}
