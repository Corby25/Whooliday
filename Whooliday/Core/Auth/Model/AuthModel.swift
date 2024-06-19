//
//  AuthModel.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

class AuthModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        
    }
    /*
    func signUp(withEmail email: String, password: String, name: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            let user = User(id: result.user.uid, name: name, email: email)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
        } catch {
            print("DEBUG: failed to create user with error \(error.localizedDescription)")
        }
        
    }
     */
    
    func signOut() {
        
    }
    
    func deleteAccount() {
        
    }
}
