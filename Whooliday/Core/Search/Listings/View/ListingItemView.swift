//
//  ListingItemView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 25/06/24.
//

import SwiftUI

struct ListingItemView: View {
    let listing: Listing
    
    var body: some View {
        
        VStack(spacing: 8){
            
            ListingImageCarouseView(listing: listing)
                .frame(height: 320)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            
            // listing details
            
            HStack(alignment: .top){
                
                VStack(alignment: .leading){
                    Text("\(listing.city) -  \(listing.state)")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(listing.name)")
                    
                    HStack(spacing: 4){
                        Text("\(listing.price)€")
                            .fontWeight(.semibold)
                    }
                    .foregroundStyle(.black)
                }
                
                Spacer()
                
                HStack(spacing:2){
                    Image(systemName: "star.fill")
                    
                    Text("\(listing.review_score)")
                }
            }
            .font(.footnote)
        }
        .padding()
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
        images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/56347948.jpg"]
    ))
}
