//
//  PayMeApp.swift
//  PayMe
//
//  Created by user244521 on 9/27/23.
//

import SwiftUI
import Firebase

@main
struct PayMeApp: App {
    @StateObject var viewModel = AuthViewModel()
    
    //Initialize Firebase
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
