//
//  UserManager.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import Observation
import Foundation

@Observable
class UserManager {
    var currentUser: User?
    
    // Computed properties
    var isLoggedIn: Bool {
        currentUser != nil
    }
    
    init(currentUser: User? = .example) {
        self.currentUser = currentUser
    }
    
    // Login method
    func login(name: String, email: String) {
        let user = User(id: UUID(), name: name, email: email, profileImage: nil, creationDate: Date())
        currentUser = user
    }
    
    // Logout method
    func logout() {
        currentUser = nil
    }
}
