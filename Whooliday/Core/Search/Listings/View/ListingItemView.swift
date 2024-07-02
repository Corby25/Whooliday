//
//  ListingItemView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 25/06/24.
//

import SwiftUI
import CoreHaptics

struct ListingItemView: View {
    let listing: Listing
    @State private var isFavorite = false
    
    var body: some View {
        VStack(spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        ListingImageCarouseView(listing: listing)
                            .frame(height: 230)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                        HeartButton(isFavorite: $isFavorite, listing: listing)
                            .padding(8)
                    }
            
            // listing details
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("\(listing.city) -  \(listing.state)")
                        .fontWeight(.bold)
                    Text("\(listing.name)")
                    
                    HStack(spacing: 4) {
                        Text("\(Int(listing.price))€")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.black)
                }
                
                Spacer()
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    
                    Text(String(format: "%.1f", listing.review_score))
                        .fontWeight(.semibold)
                }
            }
            .font(.footnote)
        }
        .padding()
    }
}


struct HeartButton: View {
    @Binding var isFavorite: Bool
    let listing: Listing
    @State private var animationAmount: CGFloat = 1
    @State private var showLoginAlert = false
    let generator = UIImpactFeedbackGenerator(style: .soft)
    
    @ObservedObject private var firebaseManager = FirebaseManager.shared
    
    var body: some View {
        Button(action: {
            if firebaseManager.isUserLoggedIn {
                toggleFavorite()
            } else {
                showLoginAlert = true
            }
        }) {
            Image(systemName: isFavorite ? "heart.fill" : "heart")
                .foregroundColor(isFavorite ? .red : .white)
                .font(.system(size: 22))
                .padding(10)
                .fontWeight(.bold)
                .clipShape(Circle())
                .scaleEffect(animationAmount)
                .overlay(
                    Circle()
                        .stroke(Color.red)
                        .scaleEffect(animationAmount)
                        .opacity(1 - animationAmount)
                        .animation(
                            .easeOut(duration: 0.3),
                            value: animationAmount
                        )
                )
        }
               .alert(isPresented: $showLoginAlert) {
                         Alert(
                             title: Text("Accesso richiesto"),
                             message: Text("Per aggiungere questo hotel ai preferiti, devi effettuare l'accesso."),
                             primaryButton: .default(Text("Accedi"), action: {
                                SigninView()
                             }),
                             secondaryButton: .cancel(Text("Annulla"))
                         )
                     }
                 }
                 
    
    
private func toggleFavorite() {
       isFavorite.toggle()
       animationAmount = 0
       withAnimation(.spring(response: 0.3, dampingFraction: 0.3, blendDuration: 0.3)) {
           animationAmount = 1
           generator.impactOccurred()
       }
       
       if isFavorite {
           firebaseManager.addFavorite(listing: listing)
       } else {
           firebaseManager.removeFavorite(listingId: listing.id)
       }
   }
}


struct ParticlesView: View {
    @State private var time: Double = 0
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            ForEach(0..<20) { _ in
                Circle()
                    .fill(Color.red)
                    .frame(width: 8, height: 8)
                    .modifier(ParticleModifier(time: time))
            }
        }
        .onReceive(timer) { _ in
            withAnimation {
                time += 0.1
            }
        }
    }
}

struct ParticleModifier: ViewModifier {
    let time: Double
    
    func body(content: Content) -> some View {
        content
            .offset(x: randomMovement(time: time), y: randomMovement(time: time))
            .opacity(1 - time)
            .scaleEffect(1 - time)
    }
    
    func randomMovement(time: Double) -> Double {
        let randomDirection = Double.random(in: -1...1)
        let randomDistance = Double.random(in: 0...100)
        return randomDirection * randomDistance * time
    }
}

#Preview {
    ListingItemView(listing: Listing(
        id: 1,
        latitude: 0.0,
        longitude: 0.0,
        city: "Milano",
        state: "IT",
        name: "Example Hotel",
        strikethrough_price: 199.99,
        review_count: 111,
        review_score: 8.8,
        checkin: "17-09-2024",
        checkout: "20-09-2024",
        nAdults: 4,
        nChildren: 2,
        childrenAge: "[2,3]",
        currency: "EUR",
        images: ["https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg"]
    ))
}
