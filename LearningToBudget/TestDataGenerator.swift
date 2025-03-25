//
//  TestDataGenerator.swift
//  LearningToBudget
//
//  Created by Christian Grise on 3/25/25.
//

import SwiftUI
import CoreData

// Test Data Generator
struct TestDataGenerator {
    // Singleton to ensure consistent data generation
    static let shared = TestDataGenerator()
    
    // Generates a full set of sample data
    func generateFullTestData(context: NSManagedObjectContext) {
        // Clear existing data first
        clearAllData(context: context)
        
        // Generate test data in sequence
        generateCategories(context: context)
        generateTransactions(context: context)
        generateBudgets(context: context)
        generateFinancialGoals(context: context)
    }
    
    // Clear existing data from all entities
    private func clearAllData(context: NSManagedObjectContext) {
        let entities = ["Category", "Transaction", "Budget", "FinancialGoal"]
        
        entities.forEach { entityName in
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try context.execute(batchDeleteRequest)
            } catch {
                print("Error clearing \(entityName) data: \(error)")
            }
        }
        
        // Save context after clearing
        do {
            try context.save()
        } catch {
            print("Error saving context after clearing: \(error)")
        }
    }
    
    // Generate sample categories
    private func generateCategories(context: NSManagedObjectContext) {
        let categoryNames = [
            // Expense Categories
            "Groceries", "Dining Out", "Transportation", "Utilities",
            "Rent/Mortgage", "Entertainment", "Shopping", "Healthcare",
            
            // Income Categories
            "Salary", "Freelance", "Investments", "Side Hustle"
        ]
        
        categoryNames.forEach { name in
            let category = Category(context: context)
            category.id = UUID()
            category.name = name
            category.type = name.contains("Salary") || name.contains("Freelance") ? "Income" : "Expense"
        }
        
        // Save categories
        do {
            try context.save()
        } catch {
            print("Error saving categories: \(error)")
        }
    }
    
    // Generate sample transactions
    private func generateTransactions(context: NSManagedObjectContext) {
        // Fetch existing categories
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            
            // Generate multiple transactions
            for month in -6...0 {  // 6 months of historical data
                let baseDate = Calendar.current.date(byAdding: .month, value: month, to: Date())!
                
                // Generate random number of transactions
                let transactionCount = Int.random(in: 10...30)
                
                for _ in 0..<transactionCount {
                    let transaction = Transaction(context: context)
                    transaction.id = UUID()
                    
                    // Randomize date within the month
                    let dayOffset = Int.random(in: 1...28)
                    transaction.date = Calendar.current.date(byAdding: .day, value: dayOffset, to: baseDate)!
                    
                    // Select random category
                    let relevantCategories = categories.filter {
                        $0.type == (month >= 0 ? "Expense" : "Income")
                    }
                    transaction.category = relevantCategories.randomElement()
                    
                    // Random amount logic
                    transaction.amount = Double.random(in: month >= 0 ? 20...500 : 1000...5000)
                    transaction.type = transaction.category?.type ?? "Expense"
                }
            }
            
            // Save transactions
            try context.save()
        } catch {
            print("Error generating transactions: \(error)")
        }
    }
    
    // Generate sample budgets
    private func generateBudgets(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            let categories = try context.fetch(fetchRequest)
            let expenseCategories = categories.filter { $0.type == "Expense" }
            
            // Create budgets for expense categories
            expenseCategories.forEach { category in
                let budget = Budget(context: context)
                budget.id = UUID()
                budget.category = category
                budget.amount = Double.random(in: 300...2000)
                budget.period = ["Monthly", "Quarterly"].randomElement()!
                budget.startDate = Date()
            }
            
            // Save budgets
            try context.save()
        } catch {
            print("Error generating budgets: \(error)")
        }
    }
    
    // Generate financial goals
    private func generateFinancialGoals(context: NSManagedObjectContext) {
        let goalTypes = [
            "Emergency Fund",
            "Vacation",
            "New Car",
            "Home Down Payment",
            "Retirement"
        ]
        
        goalTypes.forEach { type in
            let goal = FinancialGoal(context: context)
            goal.id = UUID()
            goal.name = type
            goal.targetAmount = Double.random(in: 5000...50000)
            goal.currentAmount = Double.random(in: 0...goal.targetAmount)
            
            // Random target date within 1-3 years
            let targetDate = Calendar.current.date(byAdding: .year, value: Int.random(in: 1...3), to: Date())
            goal.targetDate = targetDate
        }
        
        // Save goals
        do {
            try context.save()
        } catch {
            print("Error generating goals: \(error)")
        }
    }
}

// View to trigger test data import
struct TestDataImportView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isImporting = false
    @State private var importMessage = ""
    
    var body: some View {
        VStack {
            Button("Import Test Data") {
                importTestData()
            }
            .buttonStyle(.borderedProminent)
            
            if !importMessage.isEmpty {
                Text(importMessage)
                    .foregroundColor(.green)
            }
        }
    }
    
    private func importTestData() {
        isImporting = true
        importMessage = ""
        
        // Perform import on background thread
        DispatchQueue.global(qos: .userInitiated).async {
            let context = self.viewContext
            
            // Generate test data
            TestDataGenerator.shared.generateFullTestData(context: context)
            
            // Update UI on main thread
            DispatchQueue.main.async {
                isImporting = false
                importMessage = "Test data imported successfully!"
            }
        }
    }
}

// Optional: JSON-based Import for more complex scenarios
struct JSONTestDataImporter {
    // Structure to decode complex test data
    struct TestDataPayload: Codable {
        let transactions: [TransactionData]
        let budgets: [BudgetData]
        let goals: [GoalData]
    }
    
    // Detailed data structures for import
    struct TransactionData: Codable {
        let amount: Double
        let date: Date
        let category: String
        let type: String
    }
    
    struct BudgetData: Codable {
        let category: String
        let amount: Double
        let period: String
    }
    
    struct GoalData: Codable {
        let name: String
        let targetAmount: Double
        let currentAmount: Double
    }
    
    // Import from JSON file
    func importFromJSON(filename: String, context: NSManagedObjectContext) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            print("Could not find or read JSON file")
            return
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            
            let payload = try decoder.decode(TestDataPayload.self, from: data)
            
            // Import transactions
            payload.transactions.forEach { transData in
                let transaction = Transaction(context: context)
                transaction.amount = transData.amount
                transaction.date = transData.date
                // Additional mapping logic
            }
            
            try context.save()
        } catch {
            print("Error importing JSON: \(error)")
        }
    }
}
