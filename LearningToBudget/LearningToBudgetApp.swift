//
//  LearningToBudgetApp.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import SwiftUI

@main
struct LearningToBudgetApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(UserManager())
        }
    }
}
