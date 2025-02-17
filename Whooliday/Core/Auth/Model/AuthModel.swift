//
//  AuthModel.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth

// model to handle the signup and signin functions
@MainActor
class AuthModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    // use the firebase auth component to add an user
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            // Handle specific error cases
            print("DEBUG: failed to login user with error \(error.localizedDescription)")

            throw error
        }
    }
    
    // add the user infos to firestore
    func signUp(withEmail email: String, password: String, name: String, country: Country?, currency: Currency?) async throws {
            do {
                let result = try await Auth.auth().createUser(withEmail: email, password: password)
                self.userSession = result.user
                
                // Determine the default values for country and currency
                let defaultCountry = country ?? Country(name: "Italy", alpha2Code: "IT")
                let defaultCurrency = currency ?? Currency(name: "Euro", alpha2Code: "EUR")
                
                var user = User(id: result.user.uid, name: name, email: email, currency: defaultCurrency.alpha2Code, locale: defaultCountry.alpha2Code.lowercased(), numNotifications: 0, numFavorites: 0, sendEmail: true)
                
                // Encode and store user data in Firestore
                let encodedUser = try Firestore.Encoder().encode(user)
                try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
                
                await fetchUser()
            } catch {
                print("DEBUG: failed to register user with error \(error.localizedDescription)")
                throw error
            }
        }
    
    // use the google sign in to auth an user and add the user infos to firestore if it's the first access
    func signInGoogle() async throws {
        guard let topVC = Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        guard let idToken = gidSignInResult.user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        let accessToken = gidSignInResult.user.accessToken.tokenString
        
        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        do {
            let result = try await Auth.auth().signIn(with: credential)
            self.userSession = result.user
            
            // Check if user already exists in Firestore
            let userRef = Firestore.firestore().collection("users").document(result.user.uid)
            let snapshot = try await userRef.getDocument()
            
            if !snapshot.exists {
                // User doesn't exist in Firestore, create a new user document
                let user = User(id: result.user.uid, name: gidSignInResult.user.profile?.name ?? "Unknown", email: result.user.email ?? "Unknown", currency: "EUR", locale: "it", numNotifications: 0, numFavorites: 0, sendEmail: true)
                let encodedUser = try Firestore.Encoder().encode(user)
                try await userRef.setData(encodedUser)
            }
            await fetchUser()
        } catch {
            print("DEBUG: failed to login user with Google sign-in \(error.localizedDescription)")
            throw error
        }
    }
     
    // use the firebase auth to reset the pw
    func resetPassword(email: String) async throws {
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            print("DEBUG: failed to register user with error \(error.localizedDescription)")
            print((error as NSError).code)
            
            throw error
        }
    }
    
    // sign out the user locally using the firebase auth component
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
        } catch {
            print("DEBUG: failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func fetchUser() async {
        guard let uid =  Auth.auth().currentUser?.uid else {return}
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else {return}
        self.currentUser = try? snapshot.data(as: User.self)
    }
}
