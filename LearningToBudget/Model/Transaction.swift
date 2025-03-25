//
//  Transaction.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/25/25.
//

import Foundation

enum TransactionType {
    case income
    case expense
}

enum RecurringFrequency {
    case daily
    case weekly
    case monthly
    case yearly
}

struct Transaction: Identifiable {
    let id: UUID
    var amount: Double
    var title: String
    var date: Date
    var category: Category
    var type: TransactionType
    var notes: String?
    var isRecurring: Bool
    var recurringFrequency: RecurringFrequency?
}
