//
//  WelcomeView1.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 17/06/24.
//

import SwiftUI
import RiveRuntime
let button = RiveViewModel(fileName: "welcomeButton")

struct WelcomeView1: View {
    
    
    var body: some View {
        button.view()
            .frame(width: 236, height: 64)
            .overlay{
                Label("Let's start", systemImage: "arrow.forward")
                    .offset(x:4, y:4)
                    .font(.headline)
            }
            .background(
                Color.black
                    .cornerRadius(30)
                    .blur(radius: 10)
                    .opacity(0.2)
                    .offset(y: 10)
            )
            .onTapGesture {
                button.play()
            }
        
    }
}

#Preview {
    WelcomeView1()
}
