//
//  CardViewBig.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//

import SwiftUI


// big card for home page to show summary place details
struct CardViewBig: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let place: Place
    
    var body: some View {
        ZStack {
            VStack {
                AsyncImage(url: URL(string: "\(place.imageUrl)")) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 220)
                        .clipped()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 130)
                
                Spacer()
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(place.name)")
                            .fontWeight(.bold)
                        HStack {
                            Image(systemName: "location.fill.viewfinder")
                                .foregroundStyle(.blue)
                                .fontWeight(.bold)
                            Text("\(place.region)")
                                .font(.footnote)
                                .lineLimit(1)
                                .truncationMode(.tail)
                        }
                    }
                    .frame(width: 240, alignment: .leading)
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text(place.country)
                            .fontWeight(.semibold)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                        
                        HStack(alignment: .firstTextBaseline, spacing: 2) {
                            Image(systemName: "star.fill")
                                .foregroundStyle(.orange)
                                .fontWeight(.bold)
                            Text(String(format: "%.1f", place.rating))
                                .fontWeight(.semibold)
                        }
                        .font(.callout)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .padding()
            }
        }
        .frame(height: 249)
        .background(LinearGradient(
            gradient: Gradient(colors: [Color.gray.opacity(0.2), colorScheme == .dark ? Color.gray.opacity(0.5): Color.white.opacity(1)]),
            startPoint: .leading,
            endPoint: .trailing
        ))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    CardViewBig(place: Place(id: "kwi9", name: "Le 5 Terre", country: "Italia", region: "Liguria", rating: 4.5, imageUrl: "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg", latitude: 0.0, longitude: 0.0, nLikes: 43, description: "Test description"))
}
