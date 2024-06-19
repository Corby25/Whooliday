//
//  SwiftUIView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import SwiftUI

struct Signin: View {
    @State private var email: String = ""
    @State private var password: String = ""
    //@State private var showingSignup = false
    @EnvironmentObject var model: AuthModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
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
                    /*
                    {
                        try await model.signIn(withEmail: email, password:password)
                    }*/
                }) {
                    Text("Login")
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(5.0)
                }
                
                Spacer()
                
                Text("If you don't have an account yet click here to signup")
                    .foregroundColor(.blue)
                    .onTapGesture {
                        //self.showingSignup = true
                    }
                
                /*NavigationLink(destination: SignupView(), isActive: $showingSignup) {
                    EmptyView()
                }*/
            }
            .padding()
            .navigationBarTitle("Login")
        }
    }
}

#Preview {
    Signin()
}
