//
//  ProfileView.swift
//  Whooliday
//
//  Created by Tommaso Diegoli on 19/06/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var model: AuthModel
    
    var body: some View {
        if let user = model.currentUser {
            VStack(spacing: 20) {
                Text("Welcome, \(user.name)!")
                            .font(.title)
                        
                        Text("Email: \(user.email)")
                        
                        Button(action: {
                            model.signOut()
                        }) {
                            Text("Logout")
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.red)
                                .cornerRadius(5.0)
                        }
                    }
                    .padding()
                    .navigationBarTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
}
