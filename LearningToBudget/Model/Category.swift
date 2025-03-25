//
//  Category.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/25/25.
//

import Foundation
import SwiftUI

struct Category: Identifiable {
    let id: UUID
    var name: String
    var icon: String
    var color: Color
}
