//
//  AuthViewModel.swift
//  PayMe
//
//  Created by user244521 on 9/27/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

//form validation protocol
protocol AuthenticationFormProtocol {
    var formIsVaild: Bool { get }
}

@MainActor
class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    //checking for current users
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUserData()
        }
    }
    
    //signin function
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUserData()
        }catch {
            print("DEBUG: Fail to log in with error\(error.localizedDescription)")
        }
    }
    
    
    //createuser function
    func createUser(withEmail email: String, fullname: String, password: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, fullName: fullname, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUserData()
        }catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
            
    }
    
    //signout function
    func signOut() {
        do {
            try Auth.auth().signOut() //signs out user on backend
            self.userSession = nil //wipes out user session and redirect to login
            self.currentUser = nil
        } catch {
            print("DEBUG: Faild to signOut user with error \(error.localizedDescription)")
        }
    }
    

    //fetchuserdata from firebase function
    func fetchUserData() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
