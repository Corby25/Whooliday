//
//  WelcomeView2.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 18/06/24.
//

import SwiftUI
import Lottie
import RiveRuntime


private let button = RiveViewModel(fileName: "welcomeButton")

struct WelcomeView2: View {
   
    
    var body: some View {
        
        VStack{
            
            Button("skip"){
                
            }   .foregroundColor(.black)
                .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                .buttonStyle(PlainButtonStyle())
                .frame(width: 330, alignment: .trailing)
            
            LottieView(animation: .named("beach"))
                .playing(loopMode: .loop)
                .frame(width: 320)
                .padding(.bottom, -60)
                .padding(.top, -100)
            
            Text("Goditi.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 30, relativeTo: .headline))
            Text("Ogni.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 30, relativeTo: .headline))
            Text("Momento.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 30, relativeTo: .headline))
            
            Text("Per il resto ci pensiamo noi. Cerchiamo e ti aggiorniamo.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .headline))
                .padding(.top, 10)
        }
        
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
        
        HStack(spacing: 8) {
                
                Circle()
                .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 8, height: 8)
                Circle()
                .fill(Color.gray)
                    .frame(width: 9, height: 9)
                Circle()
                .stroke(Color.gray, lineWidth: 1)
                    .frame(width: 8, height: 8)
            }
        
        .padding(60)
    }
    
   
    
}

#Preview {
    WelcomeView2()
}
