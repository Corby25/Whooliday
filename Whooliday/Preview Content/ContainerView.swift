//
//  ContainerView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 17/06/24.
//

import SwiftUI

struct ContainerView: View {
    
    // save state of the splash screen
    
    @State private var isSleshScreenViewPresented = true
   
    var body: some View {
        if !isSleshScreenViewPresented{
            ContentView()
        }
        else{
            SplashScreenView()
        }
    }
}

#Preview {
    ContainerView()
    
}
