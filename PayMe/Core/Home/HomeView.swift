//  Created by user244521 on 9/28/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct Category_: Identifiable, Hashable {
    var id: String?
    var name: String
    var color: String
    static let all = Category_(id: nil, name: "All", color: "PlaceholderColor")
}

struct Transaction: Identifiable {
    var id: String?
    var amount: Double
    var date: Date
    var note: String
    var category: String
    var type: TransactionType
}

enum TransactionType: String, CaseIterable {
    case expense = "Expense"
    case income = "Income"
}

struct HomeView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var transactions: [Transaction] = [] // Changed from expenses to transactions
    @State private var categories: [Category_] = []
    @State private var searchText = ""
    @State private var selectedCategoryIndex = 0
    @State private var selectedTimeFrameIndex = 0
    @State private var selectedTransactionType: TransactionType = .expense

    let transactionTypeOptions: [TransactionType] = [.expense, .income]
    let timeFrameOptions = ["This Week", "This Month", "This Year"]

    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                Text("Dashboard")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                    .padding(.bottom, 10)

                // Transaction Type Selector (Expenses/Income)
                Picker("Select a Transaction Type", selection: $selectedTransactionType) {
                    ForEach(transactionTypeOptions, id: \.self) { type in
                        Text(type.rawValue)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)

                // Time Frame Picker
                Picker("Select a Time Frame", selection: $selectedTimeFrameIndex) {
                    ForEach(0..<timeFrameOptions.count, id: \.self) { index in
                        Text(timeFrameOptions[index])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(10)

                // Category Picker
                HStack {
                    Text("Category:")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding(.trailing, 10)

                    Picker("", selection: $selectedCategoryIndex) {
                        ForEach(0..<categories.count, id: \.self) { index in
                            Text(categories[index].name)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)
                }
                .onChange(of: selectedCategoryIndex) { newValue in
                    let selectedCategory = categories[newValue]
                    if selectedCategory == Category_.all {
                        fetchTransactions()
                    }
                }

                TextField("Search Transactions", text: $searchText)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(16)

                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filteredTransactions) { transaction in
                            TransactionRow(transaction: transaction)
                                .frame(maxWidth: .infinity)
                                .padding(16)
                                .background(Color.white)
                                .cornerRadius(10)
                                .shadow(color: Color.gray.opacity(0.4), radius: 3, x: 0, y: 2)
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationBarTitle("", displayMode: .large)
            .onAppear {
                loadCategoriesFromFirestore()
                fetchTransactions()
            }
        }
        .padding(.vertical, 10)
    }

    var filteredTransactions: [Transaction] {
        var filteredTransactions = transactions

        // Filter by Transaction Type
        filteredTransactions = filteredTransactions.filter { $0.type == selectedTransactionType }

        // Filter by Category
        if selectedCategoryIndex < categories.count {
            let selectedCategory = categories[selectedCategoryIndex].name
            filteredTransactions = filteredTransactions.filter { $0.category == selectedCategory }
        }

        // Filter by time frame
        switch timeFrameOptions[selectedTimeFrameIndex] {
        case "This Week":
            let startDate = Calendar.current.startOfDay(for: Date())
            filteredTransactions = filteredTransactions.filter { Calendar.current.isDate($0.date, inSameDayAs: startDate) }
        case "This Month":
            let startOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Date()))!
            let endOfMonth = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
            filteredTransactions = filteredTransactions.filter { $0.date >= startOfMonth && $0.date <= endOfMonth }
        case "This Year":
            let startOfYear = Calendar.current.date(from: Calendar.current.dateComponents([.year], from: Date()))!
            let endOfYear = Calendar.current.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
            filteredTransactions = filteredTransactions.filter { $0.date >= startOfYear && $0.date <= endOfYear }
        default:
            break
        }

        return filteredTransactions
    }

    func loadCategoriesFromFirestore() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        guard let userUID = user?.uid else {
            print("User is not authenticated.")
            return
        }

        let userCategoriesRef = db.collection("users").document(userUID).collection("categories")

        userCategoriesRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching categories: \(error.localizedDescription)")
            } else {
                if let documents = snapshot?.documents {
                    self.categories = documents.compactMap { document in
                        let data = document.data()
                        if let name = data["name"] as? String,
                           let color = data["color"] as? String {
                            return Category_(id: document.documentID, name: name, color: color)
                        }
                        return nil
                    }
                    print("Categories loaded successfully: \(self.categories)")
                }
            }
        }
    }

    func fetchTransactions() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        guard let userUID = user?.uid else {
            print("User is not authenticated.")
            return
        }

        let transactionsRef = db.collection("users").document(userUID).collection("transactions")

        transactionsRef.getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching transactions: \(error.localizedDescription)")
            } else {
                if let documents = snapshot?.documents {
                    self.transactions = documents.compactMap { document in
                        let data = document.data()
                        if let amount = data["amount"] as? Double,
                           let dateTimestamp = data["date"] as? Timestamp,
                           let note = data["note"] as? String,
                           let category = data["category"] as? String,
                           let typeString = data["type"] as? String,
                           let type = TransactionType(rawValue: typeString) {
                            let date = dateTimestamp.dateValue()
                            return Transaction(id: document.documentID, amount: amount, date: date, note: note, category: category, type: type)
                        }
                        return nil
                    }
                    print("Transactions loaded successfully: \(self.transactions)")
                }
            }
        }
    }

    struct TransactionRow: View {
        let transaction: Transaction

        var body: some View {
            VStack(alignment: .leading, spacing: 4) {
                Text("Amount: Rs. \(String(format: "%.2f", transaction.amount))")
                    .font(.title2)
                    .foregroundColor(.primary)

                Text("Date: \(formattedDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("Category: \(transaction.category)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }

        var formattedDate: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            return dateFormatter.string(from: transaction.date)
        }
    }
}

