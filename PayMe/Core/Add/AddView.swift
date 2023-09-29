//
//  AddView.swift
//  PayMe
//
//  Created by user244521 on 9/28/23.
//


import SwiftUI
import Firebase
import FirebaseFirestore

enum TransactionItemType: String, CaseIterable {
    case expense = "Expense"
    case income = "Income"
}

struct TransactionCategory: Identifiable, Hashable {
    var id: String?
    var name: String
}

struct AddView: View {
    @State private var isAlertShowing = false
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var categories: [TransactionCategory] = []
    @State private var amount: String = ""
    @State private var date: Date = Date()
    @State private var note: String = ""
    @State private var selectedCategoryIndex = 0
    @State private var selectedTransactionType: TransactionItemType = .expense // Initialize with Expense

    var selectedCategory: TransactionCategory? {
        if categories.indices.contains(selectedCategoryIndex) {
            return categories[selectedCategoryIndex]
        }
        return nil
    }

    var body: some View {
        VStack {
            Text("Add Transaction")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            Picker("Transaction Type", selection: $selectedTransactionType) {
                ForEach(TransactionItemType.allCases, id: \.self) { type in
                    Text(type.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal, 20)
            .padding(.bottom, 20)

            VStack(alignment: .leading, spacing: 20) {
                TextField("Amount", text: $amount)
                    .keyboardType(.decimalPad)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)

                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)

                TextField("Note", text: $note)
                    .padding(10)
                    .background(Color.white)
                    .cornerRadius(10)

                Picker("Category", selection: $selectedCategoryIndex) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        Text(categories[index].name)
                    }
                }
                .pickerStyle(DefaultPickerStyle())
                .padding(10)
                .background(Color.white)
                .cornerRadius(10)
            }
            .padding(20)

            Button(action: {
                handleCreate()
            }) {
                Text("Submit Transaction")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(20)

            Spacer()
        }
        .onAppear {
            // Fetch categories for the AddTransactionView when it appears
            loadCategoriesForAddView()
        }
    }

    func loadCategoriesForAddView() {
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
                    self.categories.removeAll()

                    for document in documents {
                        let data = document.data()
                        if let name = data["name"] as? String {
                            // Ensure that the "id" field is retrieved as a string
                            let id = document.documentID
                            let category = TransactionCategory(id: id, name: name)
                            self.categories.append(category)
                        }
                    }
                }
            }
        }
    }

    func handleCreate() {
        let db = Firestore.firestore()
        let user = Auth.auth().currentUser

        guard let userUID = user?.uid else {
            print("User is not authenticated.")
            return
        }

        guard let selectedCategory = selectedCategory else {
            print("No category selected.")
            return
        }

        guard let amountDouble = Double(amount) else {
            print("Invalid amount.")
            return
        }

        var transactionData: [String: Any] = [
            "amount": amountDouble,
            "date": date,
            "note": note,
            "category": selectedCategory.name
        ]

        if selectedTransactionType == .expense {
            transactionData["type"] = "Expense"
        } else {
            transactionData["type"] = "Income"
        }

        db.collection("users").document(userUID).collection("transactions").addDocument(data: transactionData) { error in
            if let error = error {
                print("Error adding transaction: \(error.localizedDescription)")
            } else {
                print("Transaction added successfully.")
                // Reset the form fields
                amount = ""
                date = Date()
                note = ""
            }
        }
    }
}

struct AddTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        AddView()
    }
}
