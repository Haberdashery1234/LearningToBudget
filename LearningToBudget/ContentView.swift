//
//  ContentView.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(UserManager.self) private var userManager
        
    var body: some View {
        Group {
            if let user = userManager.currentUser {
                TabView {
                    DashboardView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Dashboard")
                        }
                    
                    TransactionsView()
                        .tabItem {
                            Image(systemName: "wallet.bifold")
                            Text("Budgets")
                        }
                    
                    ReportsView()
                        .tabItem {
                            Image(systemName: "chart.bar")
                            Text("Reports")
                        }
                    
                    ProfileView(user: user)
                        .tabItem {
                            Image(systemName: "person")
                            Text("Profile")
                        }
                }
            } else {
                LoginView()
            }
            #if DEBUG
            TestDataImportView()
            #endif
        }
    }
}

#Preview {
    ContentView()
}
