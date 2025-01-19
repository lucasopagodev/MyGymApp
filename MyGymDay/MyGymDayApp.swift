//
//  MyGymDayApp.swift
//  MyGymDay
//
//  Created by Lucas Rodrigues on 09/01/25.
//

import SwiftUI
import SwiftData

@main
struct MyGymDayApp: App {
    @StateObject private var viewModel = GymViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .modelContainer(for: [Workout.self, Exercise.self])
        }
    }
}
