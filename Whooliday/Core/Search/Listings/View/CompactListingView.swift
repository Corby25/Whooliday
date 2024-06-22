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
        
        HStack {
            // Image
            ListingImageCarouseView(listing: listing)
                .frame(width: 100, height: 150)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
            // Details
            VStack(alignment: .trailing, spacing: 4) {
                Text(listing.name)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                HStack {
                    Image(systemName: "star.fill")
                    Text(String(format: "%.1f", listing.review_score))
                }
                .foregroundColor(.black)
                .font(.footnote)
                
                Text("\(Int(listing.price))€")
                    .fontWeight(.semibold)
                    
            }
            .foregroundColor(.black)
            
            Spacer()
        }
        .frame(height: 150)
        .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: 8))
        
    }
}

#Preview {
    CompactListingView(listing: Listing(id: 1, latitude: 0.0, longitude: 0.0, name: "Example Hotel", strikethrough_price: 199.99, review_count: 111, review_score: 8.8, images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/56347948.jpg"]))
}
