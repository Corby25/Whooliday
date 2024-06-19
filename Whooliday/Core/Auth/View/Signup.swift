//
//  SwiftUIView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import SwiftUI

struct Signup: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    //@EnvironmentObject var model: AuthModel
    
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
                /*
                {
                    try await model.signUp(withEmail: email, password: password, name: name)
                }*/
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
    }
}

#Preview {
    Signup()
}
