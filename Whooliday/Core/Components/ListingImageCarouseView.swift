//
//  ListingImageCarouseView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct ListingImageCarouseView: View {
    let listing: Listing
    
    var body: some View {
        TabView {
            ForEach(listing.images, id: \.self) { imageUrl in
                AsyncImage(url: URL(string: imageUrl)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .tabViewStyle(.page)
    }
}

#Preview {
    ListingDetailView(listing: Listing(id: 1, latitude: 0.0, longitude: 0.0, name: "Example Hotel", strikethrough_price: 199.99, review_count: 111, review_score: 8.8, images: ["https://example.com/image.jpg"]))
}
