//
//  ListingImageCarouseView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

// corouse images view
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

