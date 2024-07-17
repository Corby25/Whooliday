//
//  LoadingView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 22/06/24.
//

import SwiftUI

import Lottie


// loading view used to show some phrases while waiting for a response from customAPI
struct LoadingView: View {
    
    @Binding var isPresented: Bool
    let phrases = [NSLocalizedString("Did you know that 20 of bookings are canceled in the month before the booked date?", comment: ""), NSLocalizedString("Loading... have a coffee and relax!", comment: ""), NSLocalizedString("Loading is the new cardio!", comment: ""), NSLocalizedString("There's no need for a personal trainer when you have a load that makes you sweat.", comment: "")]
    @State private var selectedPhrase: String = ""
    @State private var opacity: Double = 1.0
    
    let timer = Timer.publish(every: 4, on: .main, in: .common).autoconnect()
    
    
    
    var body: some View {
        ZStack {
            
            
            VStack(alignment: .center) {
                LottieView(name: "loading")
                    .frame(width: 400, height: 400)
                
                Text(selectedPhrase)
                    .font(.headline)
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                
            }
            
        }
        .onAppear {
            selectedPhrase = phrases.randomElement() ?? ""
        }
        .onReceive(timer) { _ in
            withAnimation(.easeInOut(duration: 0.5)) {
                opacity = 0
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                selectedPhrase = phrases.randomElement() ?? ""
                withAnimation(.easeInOut(duration: 0.5)) {
                    opacity = 1
                }
            }
        }
    }
}


private struct LottieView: UIViewRepresentable {
    var name: String
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
        animationView.animation = LottieAnimation.named(name)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .autoReverse
        animationView.play()
        
        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
}


#Preview {
    LoadingView(isPresented: .constant(false))
}

