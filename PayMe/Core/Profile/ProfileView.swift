//
//  ProfileView.swift
//  PayMe
//
//  Created by user244521 on 9/27/23.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        if let user = viewModel.currentUser {
            NavigationView {
                List {
                    Section{
                        HStack{
                            Text(user.initials)
                                .font(.title)
                                .foregroundColor(Color(.white))
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray))
                                .clipShape(Circle())
                            
                            VStack (alignment: .leading, spacing: 4){
                                Text(user.fullName)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top,4)
                                
                                Text(user.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                                    
                    Section("Categories") {
                        NavigationLink(destination: CategoryView()) {
                            SettingsRowVIew(imageName: "square.grid.2x2.fill",
                                            title: "Add Categories",
                                            tintColor: Color(.systemGray))
                        }
                    }
                    
                    
                    Section("Reports") {
                        NavigationLink(destination: ReportView()) {
                            SettingsRowVIew(imageName: "chart.pie.fill",
                                            title: "Reports",
                                            tintColor: Color(.systemGray))
                        }
                    }
                    Section("Account") {
                        Button {
                            viewModel.signOut()
                        } label: {
                            SettingsRowVIew(imageName: "arrow.left.circle.fill",
                                            title: "Sign Out",
                                            tintColor: .red)
                        }
                    }
                }
            }
        }
    }
}


struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
