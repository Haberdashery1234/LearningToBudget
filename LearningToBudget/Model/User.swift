//
//  User.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/24/25.
//

import Observation
import Foundation

@Observable
class User: Codable, Identifiable {
    var id: UUID = UUID()
    var name: String = ""
    var email: String = ""
    var profileImage: Data?
    var creationDate: Date
    
    init(id: UUID, name: String, email: String, profileImage: Data? = nil, creationDate: Date = .now) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImage = profileImage
        self.creationDate = creationDate
    }
    
    static let example = User(id: UUID(), name: "Andy", email: "andy@andy.com")
}
