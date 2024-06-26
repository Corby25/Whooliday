//
//  CardViewSmall.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//

import SwiftUI

struct CardViewSmall: View {
    let place: Place
    var body: some View {
        VStack(spacing: 0) {
            AsyncImage(url: URL(string: place.imageUrl)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            } placeholder: {
                ProgressView()
            }
            .frame(height: 180)

            HStack(alignment: .top, spacing: 0) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(place.name)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    
                    HStack(spacing: 2) {
                        Image(systemName: "location.fill.viewfinder")
                            .foregroundColor(.blue)
                            .font(.footnote)
                        Text(place.region)
                            .font(.footnote)
                            .lineLimit(1)
                            .truncationMode(.tail)
                    }
                    .font(.footnote)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .trailing, spacing: 8) {
                    Text(place.country)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.trailing)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)

                    HStack(alignment: .firstTextBaseline, spacing: 1) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.orange)
                            .font(.footnote)
                        Text(String(format: "%.1f", place.rating))
                            .fontWeight(.semibold)
                            .font(.footnote)
                    }
                    .font(.callout)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
        .frame(width: 180, height: 249)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.gray.opacity(0.2), Color.white.opacity(1)]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    CardViewSmall( place: Place(id: "eijewpoe3", name: "Roma", country: "Italia", region: "Lazio", rating: 4.5, imageUrl: "https://img.freepik.com/premium-photo/background-paris_219717-5461.jpg"))
}
