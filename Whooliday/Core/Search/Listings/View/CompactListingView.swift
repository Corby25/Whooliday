//
//  CompactListingView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 22/06/24.
//

import SwiftUI

struct CompactListingView: View {
    @Environment(\.colorScheme) var colorScheme
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            ListingImageCarouseView(listing: listing)
                .frame(width: 120, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            
            // Details
            VStack(alignment: .leading, spacing: 10) {
                Text(listing.name)
                    .font(.headline)
                    .fontWeight(.bold)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "bookmark.circle.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", listing.review_score))
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                
                Spacer()
                
                Text("\(Int(listing.price))€")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(backgroundStyle)
        .cornerRadius(20)
        .shadow(color: shadowColor, radius: 10, x: 0, y: 5)
        .padding(.horizontal)
    }
    
    private var backgroundStyle: some View {
        Group {
            if colorScheme == .dark {
                Color(.systemGray6)
            } else {
                Color.white
            }
        }
    }
    
    private var shadowColor: Color {
        colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.2)
    }
}

#Preview {
    CompactListingView(listing: Listing(
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
        images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/56347948.jpg"]
    ))
}
