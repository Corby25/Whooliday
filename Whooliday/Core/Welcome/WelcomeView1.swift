//
//  WelcomeView1.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 17/06/24.
//

import SwiftUI
import RiveRuntime
private let button = RiveViewModel(fileName: "welcomeButton")
let imgAnimation = RiveViewModel(fileName: "pag1")


struct WelcomeView1: View {
    
    @State private var path = NavigationPath()
    @State private var offset: CGFloat = 0.0

    var body: some View {
        NavigationStack(path: $path){
            VStack{
                
                
                Button("skip"){
                    
                }   .foregroundColor(.black)
                    .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                    .buttonStyle(PlainButtonStyle())
                    .frame(width: 330, alignment: .trailing)
                
                
                
                imgAnimation.view()
                    .onAppear() {
                        imgAnimation.play()
                    }
                    .frame(width: 350, alignment: .center)
                
                
                Text("Risparmia ora.")
                    .font(.custom("TT Hoves Pro Trial Bold", size: 30, relativeTo: .headline))
                    .frame(width: 300, alignment: .center)
                
                Text("Senza fatica.")
                    .font(.custom("TT Hoves Pro Trial DemiBold", size: 30, relativeTo: .headline))
                    .frame(width: 300, alignment: .center)
                    .padding(.bottom, 20)
                
                Text("E' semplice, cerca un luogo o seleziona un hotel. Riceverai una notifica quando il prezzo si abbassa.")
                    .font(.custom("TT Hoves Pro Trial Regular", size: 18, relativeTo: .body))
                    .multilineTextAlignment(.center)
                    .frame(width: 350, alignment: .center)
                    .lineSpacing(3)
                    .padding(.bottom, 50)
                
                
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
                        path.append("Tutorial1")
                    }
                    .navigationDestination(for: String.self){
                        value in if value == "Tutorial1"{WelcomeView2()}
                    }
                
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 9, height: 9)
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 8, height: 8)
                    Circle()
                        .stroke(Color.gray, lineWidth: 1)
                        .frame(width: 8, height: 8)
                }
                
                .padding(.top, 60)
                
            
            }
        }
        .gesture(
                        DragGesture()
                            .onChanged { gesture in
                                offset = gesture.translation.width
                            }
                            .onEnded { gesture in
                                if gesture.translation.width < -100 {
                                    // Swipe left: go to DetailView
                                    path.append("Tutorial1")
                                }
                                offset = 0
                                   
                               
                            }
                    )
    }
}

#Preview {
    WelcomeView1()
}
