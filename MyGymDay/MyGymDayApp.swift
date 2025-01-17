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
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: [Workout.self, Exercise.self])
        }
    }
}
