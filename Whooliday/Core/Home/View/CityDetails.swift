//
//  CityDetails.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 02/07/24.
//

import SwiftUI
import MapKit

struct CityDetailView: View {
    var place: Place
    @State private var showFullDescription = false
    @State private var isFavorite = false
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    // Hero Image
                    AsyncImage(url: URL(string: place.imageUrl)) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 250)
                            .clipped()
                            .overlay(
                                LinearGradient(gradient: Gradient(colors: [.clear, .black.opacity(0.7)]), startPoint: .top, endPoint: .bottom)
                            )
                    } placeholder: {
                        Color.gray
                            .frame(height: 250)
                    }
                    
                    // City Info
                    VStack(alignment: .leading, spacing: 15) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(place.name)
                                    .font(.system(size: 28, weight: .bold, design: .rounded))
                                    .lineLimit(2)
                                    .minimumScaleFactor(0.5)
                                Text("\(place.region), \(place.country)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            Spacer()
                            Button(action: { isFavorite.toggle() }) {
                                Image(systemName: isFavorite ? "heart.fill" : "heart")
                                    .foregroundColor(isFavorite ? .red : .gray)
                                    .font(.title2)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        // Rating
                        HStack {
                            ForEach(0..<5) { index in
                                Image(systemName: index < Int(place.rating) ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                            Text(String(format: "%.1f", place.rating))
                                .fontWeight(.semibold)
                        }
                        
                        // Description
                        Text("descrizione ")
                            .lineLimit(showFullDescription ? nil : 3)
                            .font(.body)
                        
                        Button(action: { showFullDescription.toggle() }) {
                            Text(showFullDescription ? "Read less" : "Read more")
                                .font(.caption)
                                .foregroundColor(.blue)
                        }
                        
                        // Map
                        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
                        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
                        
                        Map(coordinateRegion: .constant(region), annotationItems: [place]) { place in
                            MapAnnotation(coordinate: coordinate) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.red)
                                    .font(.title)
                            }
                        }
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                        )
                        
                        // Weather info (placeholder)
                        HStack {
                            Image(systemName: "sun.max.fill")
                                .foregroundColor(.yellow)
                            Text("25°C")
                            Spacer()
                            Text("Sunny")
                        }
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                }
                .frame(width: geometry.size.width)
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    CityDetailView(place: Place(id: "30ie", name: "Le 5 Terre", country: "Italia", region: "Liguria", rating: 4.5, imageUrl: "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg", latitude: 44.1461, longitude: 9.6439)
    )
}
