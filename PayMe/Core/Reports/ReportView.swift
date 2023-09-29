//
//  ReportView.swift
//  PayMe
//
//  Created by user244521 on 9/28/23.
//

import SwiftUI

struct ReportView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}


//import SwiftUI
//
//struct ReportView: View {
//    @State private var expenses: [Transaction] = [] // Store your filtered expenses here
//    @State private var selectedTimeFrameIndex = 0 // Initial time frame selection
//    let timeFrameOptions = ["This Week", "This Month", "This Year"]
//
//    var body: some View {
//        VStack {
//            Text("Expense Report")
//                .font(.title)
//
//            // Time Frame Picker
//            Picker("Select a Time Frame", selection: $selectedTimeFrameIndex) {
//                ForEach(0..<timeFrameOptions.count, id: \.self) { index in
//                    Text(timeFrameOptions[index])
//                }
//            }
//            .pickerStyle(SegmentedPickerStyle())
//            .padding()
//
//            DonutChartView(data: generateDonutChartData(expenses: expenses))
//                .frame(width: 200, height: 200) // Adjust size as needed
//                .padding()
//
//            // Add other report details or information here
//        }
//        .onAppear {
//            // Fetch expenses based on the selected time frame
//            fetchExpensesForSelectedTimeFrame()
//
//            // Calculate the total expense
//            let totalExpense = expenses.reduce(0) { $0 + $1.amount }
//            print("Total Expense: \(totalExpense)") // Print the total expense for testing
//        }
//    }
//
//    // Helper function to fetch expenses for the selected time frame
//    private func fetchExpensesForSelectedTimeFrame() {
//        // Implement your logic to fetch expenses based on the selected time frame
//        // For example, filter expenses from the 'transactions' array based on the selected time frame
//        // You can use a switch statement to filter expenses by week, month, or year
//        // Update the 'expenses' array with the filtered expenses
//        // Sample logic:
//        let calendar = Calendar.current
//        let currentDate = Date()
//
//        switch timeFrameOptions[selectedTimeFrameIndex] {
//        case "This Week":
//            expenses = transactions.filter { calendar.isDate($0.date, inSameDayAs: currentDate) && $0.type == .expense }
//        case "This Month":
//            expenses = transactions.filter { calendar.isDate($0.date, inSameDayAs: currentDate) && $0.type == .expense }
//        case "This Year":
//            expenses = transactions.filter { calendar.isDate($0.date, inSameDayAs: currentDate) && $0.type == .expense }
//        default:
//            break
//        }
//    }
//
//    // Helper function to generate data for the DonutChartView
//    private func generateDonutChartData(expenses: [Transaction]) -> [(Double, Color)] {
//        // Calculate the percentage of each expense in the total expense
//        let totalExpense = expenses.reduce(0) { $0 + $1.amount }
//        return expenses.map { (Double($0.amount / totalExpense), .random) } // Replace .random with your desired colors
//    }
//}
