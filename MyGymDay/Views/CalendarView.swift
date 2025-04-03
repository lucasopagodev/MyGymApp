//
//  CalendarView.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 26/02/25.
//
import SwiftUI

struct CalendarView: View {
    @EnvironmentObject var viewModel: GymViewModel
    @State private var currentDate = Date()
    
    var body: some View {
        NavigationView {
            VStack {
                // Título do mês e botões para navegar entre meses
                HStack {
                    Button(action: { changeMonth(by: -1) }) {
                        Image(systemName: "chevron.left")
                    }
                    
                    Text(currentMonthYear())
                        .font(.title2)
                        .bold()
                        .padding(.horizontal)
                    
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: "chevron.right")
                    }
                }
                .padding()

                // Grid do calendário
                LazyVGrid(columns: Array(repeating: GridItem(), count: 7), spacing: 10) {
                    ForEach(weekdays(), id: \.self) { day in
                        Text(day)
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                    }
                    
                    ForEach(daysInMonth(), id: \.self) { day in
                        Button(action: { print("Treinos em \(dayString(day))") }) {
                            Text("\(Calendar.current.component(.day, from: day))")
                                .frame(width: 40, height: 40)
                                .background(hasWorkout(on: day) ? Color.green.opacity(0.7) : Color.clear)
                                .clipShape(Circle())
                        }
                        .foregroundColor(.primary)
                    }
                }
                .padding()

                Spacer()
            }
            .navigationTitle("Calendário")
        }
    }

    // Retorna os nomes dos dias da semana
    private func weekdays() -> [String] {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.shortWeekdaySymbols ?? []
    }

    // Retorna os dias do mês atual
    private func daysInMonth() -> [Date] {
        let calendar = Calendar.current
        let range = calendar.range(of: .day, in: .month, for: currentDate)!
        let firstDay = calendar.date(from: calendar.dateComponents([.year, .month], from: currentDate))!
        
        return range.compactMap { day in
            calendar.date(byAdding: .day, value: day - 1, to: firstDay)
        }
    }

    // Verifica se há treino no dia
    private func hasWorkout(on date: Date) -> Bool {
        return viewModel.workouts.contains { workout in
            Calendar.current.isDate(workout.date, inSameDayAs: date)
        }
    }

    // Formata o mês e ano atual
    private func currentMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: currentDate).capitalized
    }

    // Troca o mês
    private func changeMonth(by value: Int) {
        if let newDate = Calendar.current.date(byAdding: .month, value: value, to: currentDate) {
            currentDate = newDate
        }
    }
    
    // Retorna string formatada para debug
    private func dayString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter.string(from: date)
    }
}

struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        // Criação de alguns exercícios de exemplo com as novas propriedades
        let exercise1 = Exercise(name: "Agachamento", repetitions: "8-10", sets: 4, restTime: 90, observation: "Importante manter a postura correta.", position: 1)
        let exercise2 = Exercise(name: "Supino", repetitions: "10-12", sets: 3, restTime: 60, observation: "Cuidado com a forma.", position: 2)
        let exercise3 = Exercise(name: "Correr na esteira", repetitions: "N/A", sets: 1, restTime: 120, observation: "Aumente a velocidade gradualmente.", position: 1)
        
        // Criação de alguns treinos com os exercícios associados
        let workout1 = Workout(name: "Treino de Força", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 26))!)
        workout1.exercises = [exercise1, exercise2]
        
        let workout2 = Workout(name: "Treino Cardio", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 28))!)
        workout2.exercises = [exercise3]
        
        let workout3 = Workout(name: "Treino Flexibilidade", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 14))!)
        workout3.exercises = [exercise1]
        
        let workout4 = Workout(name: "Treino Flexibilidade 2", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 10))!)
        workout3.exercises = [exercise1, exercise3]
        
        let workout5 = Workout(name: "Treino Flexibilidade 3", date: Calendar.current.date(from: DateComponents(year: 2025, month: 2, day: 9))!)
        workout3.exercises = [exercise1, exercise2]
        
        // Inicializa o viewModel com os treinos de exemplo
        let viewModel = GymViewModel()
        viewModel.workouts = [workout1, workout2, workout3, workout4, workout5]
        
        return CalendarView()
            .environmentObject(viewModel) // Passa o viewModel com os treinos para o preview
    }
}
