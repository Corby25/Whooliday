//
//  CompactListingView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 22/06/24.
//

import SwiftUI

struct CompactListingView: View {
    let listing: Listing
    
    var body: some View {
        HStack(spacing: 16) {
            // Image
            ListingImageCarouseView(listing: listing)
                .frame(width: 120, height: 140)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .gray.opacity(0.3), radius: 4, x: 0, y: 2)
            
            // Details
            VStack(alignment: .leading, spacing: 8) {
                Text(listing.name)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", listing.review_score))
                        .fontWeight(.medium)
                }
                .font(.subheadline)
                
                Spacer()
                
                Text("\(Int(listing.price))€")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
            }
            .foregroundColor(.primary)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: .gray.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
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
