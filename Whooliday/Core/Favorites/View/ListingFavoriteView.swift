//
//  ListingFavoriteView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 02/07/24.
//

import SwiftUI

struct ListingFavoriteView: View {
    let listing: Listing
    @State private var isFavorite = true
    
    var body: some View {
        
        HStack(){
            
            ListingImageCarouseView(listing: listing)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 160)
            
            
            VStack(alignment: .leading){
                Text("Hotel Example")
                    .padding(.bottom, 25)
                    .fontWeight(.semibold)
                
                HStack(spacing: 2) {
                    Image(systemName: "star.fill")
                        .foregroundColor(.orange)
                    
                    Text(String(format: "%.1f", listing.review_score))
                        .fontWeight(.semibold)
                }
            }
            .padding()
            
            
            Spacer()
            
            HeartButtonFavourite(isFavorite: $isFavorite, listing: listing)
                .padding(8)
            
            
            
            
            
        }
        .frame(height: 130)
        .background(Color.white) // Aggiungi uno sfondo se necessario
        .cornerRadius(10) // Arrotonda gli angoli se desiderato
        .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
        .padding()
        
        
    }
}

struct HeartButtonFavourite: View {
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
            Image(systemName: isFavorite ? "heart" : "heart.fill")
                .foregroundColor(isFavorite ? .black : .red)
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


struct ListingFavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        ListingFavoriteView(listing: Listing(
            id: 1,
            latitude: 0.0,
            longitude: 0.0,
            city: "Bobo",
            state: "",
            name: "Brown Hotels Bobo",
            strikethrough_price: 199.99,
            review_count: 111,
            review_score: 4.8,
            checkin: "17-09-2024",
            checkout: "20-09-2024",
            nAdults: 4,
            nChildren: 2,
            childrenAge: "[2,3]",
            currency: "EUR",
            images: ["https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg"]
        ))
        .previewLayout(.sizeThatFits)
        .padding()
    }
}

