//
//  SplashScreenView2.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 19/06/24.
//

import SwiftUI
import RiveRuntime
import CoreHaptics

struct SplashScreenView2: View {
    
    let textAnimationIntro = RiveViewModel(fileName: "introSplash")
    
    
    // Timer properties
    @State private var timer: Timer?
    
    
    
    let generator = UIImpactFeedbackGenerator(style: .light)
   

  
    
    
    func startTypingAnimation() {
        
        var itr = 0
        generator.prepare()
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true){ timer in
            if ( itr > 3) {
                generator.impactOccurred()
            }
            else if (itr < 4){
                itr += 1
            }
            else{
                
                timer.invalidate()
            }
        }
    }
    
    var body: some View {
       
        
        textAnimationIntro.view()
            .onAppear{
                startTypingAnimation()
                textAnimationIntro.play()
            }
            
            .ignoresSafeArea()
        
    }
    
   
}

#Preview {
    SplashScreenView2()
}
