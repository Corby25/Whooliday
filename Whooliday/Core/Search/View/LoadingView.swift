//
//  LoadingView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 22/06/24.
//

import SwiftUI

import Lottie

struct LoadingView: View {
    
    @Binding var isPresented: Bool
    let phrases = ["Sai che il 20% delle prenotazioni vengono annullate nel mese precendete alla data prenotata?", "Caricamento in corso... prendetevi un caffè e rilassatevi!", "Caricare è il nuovo cardio!", "Non c'è bisogno di un personal trainer quando hai un caricamento che ti fa aspettare."]
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
                    .foregroundColor(.black)
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
    
