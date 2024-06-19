//
//  WelcomeView2.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 18/06/24.
//

import SwiftUI
import Lottie
import RiveRuntime
import CoreHaptics


private let button = RiveViewModel(fileName: "welcomeButton")

struct WelcomeView2: View {
    
    
    
    // Timer properties
    @State private var timer: Timer?

  
    // Text
    @State private var displayedTextFirst = ""
    @State private var displayedTextSecond = ""
    @State private var displayedTextThird  = ""
    
    private let fullTextFirst = "Goditi."
    private let fullTextSecond = "Ogni."
    private let fullTextThird = "Momento."
    
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    @State private var itr = 0
    

    func startTypingAnimation() {
        
        var index = 0
        
        generator.prepare()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true){ timer in
            if (index < fullTextFirst.count && itr > 3) {
                let char = fullTextFirst[fullTextFirst.index(fullTextFirst.startIndex, offsetBy: index)]
                displayedTextFirst += String(char)
                generator.impactOccurred()
                index += 1
            }
            else if (itr < 4){
                itr += 1
            }
            else{
                timer.invalidate()
            }
        }
    }
    
    func startTypingAnimationSecond() {
        
        var index = 0
        
        generator.prepare()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true){ timer in
            if (index < fullTextSecond.count && itr > 15) {
                let char = fullTextSecond[fullTextSecond.index(fullTextSecond.startIndex, offsetBy: index)]
                displayedTextSecond += String(char)
                generator.impactOccurred()
                index += 1
            }
            else if (itr < 16){
                itr += 1
                
            }
            else{
                timer.invalidate()
            }
        }
    }
    
    func startTypingAnimationThird() {
        
        var index = 0
        
        generator.prepare()
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.06, repeats: true){ timer in
            if (index < fullTextThird.count && itr > 19) {
                let char = fullTextThird[fullTextThird.index(fullTextThird.startIndex, offsetBy: index)]
                displayedTextThird += String(char)
                generator.impactOccurred()
                index += 1
            }
            else if (itr < 20){
                itr += 1
                
            }
            else{
                timer.invalidate()
            }
        }
    }
   
    
    var body: some View {
        
        VStack{
            ZStack{
                
                
                LottieView(animation: .named("beach"))
                    .playing(loopMode: .loop)
                    .frame(width: 320)
                    .padding(.bottom, -60)
                    .padding(.top, -100)
                
                Button("skip"){
                    
                }   .foregroundColor(.black)
                    .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 330, alignment: .trailing)
                    .padding(.bottom, 320)
            }
            
            
            
            Text(displayedTextFirst)
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
                .onAppear{
                    startTypingAnimation()
                }
            
            Text(displayedTextSecond)
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
                .onAppear{
                    startTypingAnimationSecond()
                }
            
            Text(displayedTextThird)
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
                .onAppear{
                    startTypingAnimationThird()
                }
            
          
            /*
            Text("Goditi.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
            
            Text("Ogni.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
             
           
            Text("Momento.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Bold", size: 35, relativeTo: .headline))
            */
            Text("Per il resto ci pensiamo noi. Controlliamo per te e ti aggiorniamo.")
                .frame(width: 300, alignment: .leading)
                .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .headline))
                .padding(.top, 10)
        }
        
        Spacer()
        
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
        
        .padding(.top, 60)
    }
    
   
    
}

#Preview {
    WelcomeView2()
}
