//
//  ContentView.swift
//  PayMe
//
//  Created by user244521 on 9/27/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        if viewModel.userSession != nil {
            TabView() {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }

                
                AddView()
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }
                
                ProfileView()
                    .tabItem {
                        Label("Settings", systemImage: "gearshape.fill")
                    }

            }
            .accentColor(.blue) // Set the tab bar color
            
            //CustomTabBar(selectedTabs: $selectedTab)
        } else {
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
