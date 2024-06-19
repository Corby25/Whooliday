//
//  WhoolidayApp.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 16/06/24.
//

import SwiftUI
import Firebase

@main
struct WhoolidayApp: App {
    @StateObject var model = AuthModel()

    /*var body: some Scene {
        WindowGroup {
            ContainerView()
                .environmentObject(model)
        }
    }*/
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .environmentObject(model)
        }
    }
    
}

