//
//  SwiftUIView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import SwiftUI
import Firebase

struct SignupView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @EnvironmentObject var model: AuthModel
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Name", text: $name)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .autocapitalization(.words)
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(5.0)
            
            Button(action: {
                Task {
                    if name.isEmpty {
                        alertMessage = "Name cannot be empty, please try again"
                        showAlert = true
                        return
                    }
                    
                    do {
                        try await model.signUp(withEmail: email, password: password, name: name)
                    } catch {
                        handleSignUpError(error)
                    }
                }
            }) {
                Text("Signup")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(5.0)
            }
            
            Spacer()
        }
        .padding()
        .navigationBarTitle("Signup", displayMode: .inline)
        .environmentObject(model)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Error"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func handleSignUpError(_ error: Error) {
        switch (error as NSError).code {
        case 17026:
            alertMessage = "The password must be 6 characters long or more, please try again"
        case 17034:
            alertMessage = "An email address must be provided, please try again"
        case 17008:
            alertMessage = "The email is not in the correct format, please try again"
        case 17004:
            alertMessage = "There is already another user with this email, please try again"
        case 17007:
            alertMessage = "There is already another user with this email, please try again"
        default:
            alertMessage = "Something went wrong, please try again"
        }
        
        // Show the alert popup
        showAlert = true
        
        // Blank the password field
        password = ""
    }
}

#Preview {
    SignupView()
}
