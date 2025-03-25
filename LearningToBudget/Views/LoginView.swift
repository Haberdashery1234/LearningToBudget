//
//  LoginView.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import SwiftUI
import Foundation

struct LoginView: View {
    @State private var username = ""
    @State private var email = ""
    
    // Using new environment binding
    @Environment(UserManager.self) private var userManager
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
            TextField("Email", text: $email)
            
            Button("Login") {
                userManager.login(name: username, email: email)
            }
        }
    }
}
