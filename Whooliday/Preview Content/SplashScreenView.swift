//
//  SplashScreenView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 17/06/24.
//

import SwiftUI
import CoreHaptics


struct SplashScreenView: View {
    
    
    // Timer properties
    @State private var timer: Timer?
  
    
    // Text
    @State private var displayedText = ""
    private let fullText = "Whooliday"
    
    let generator = UIImpactFeedbackGenerator(style: .light)
    
    
    func startTypingAnimation() {
        
        var index = 0
        var itr = 0
        generator.prepare()
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true){ timer in
            if (index < fullText.count && itr > 3) {
                let char = fullText[fullText.index(fullText.startIndex, offsetBy: index)]
                displayedText += String(char)
                generator.impactOccurred()
                index += 1
            }
            else if (itr < 4){
                itr += 4
            }
            else{
                timer.invalidate()
            }
        }
    }
    var body: some View {
        
        // Z means one top of another
        VStack{
            
            Text(displayedText)
                .font(.largeTitle)
                .fontWeight(.bold)
            }
        .onAppear{
            startTypingAnimation()
        }
        }
        
    }
    
    struct SplashView_Previews: PreviewProvider {
        static var previews: some View {
            SplashScreenView()
        }
    }


