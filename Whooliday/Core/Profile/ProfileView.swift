//
//  ProfileView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 32) {
            VStack(alignment: .leading, spacing: 8){
                Text("Profile")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                
                Text("Inzia a programmare la tua vacanza")
                
                Button{
                    print("Log in")
                } label:
                {
                    Text("Log in")
                        .foregroundStyle(.white)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .frame(width: 360, height: 48)
                        .background(.pink)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
