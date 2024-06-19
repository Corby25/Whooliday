//
//  ContainerView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 17/06/24.
//

import SwiftUI

struct ContainerView: View {
    
    // save state of the splash screen
    @EnvironmentObject var model: AuthModel
   
    var body: some View {
        Group {
            if model.userSession != nil {
                ProfileView()
            } else {
                SigninView()
            }
        }
       
    }
}

#Preview {
    ContainerView()
    
}
