//
//  CityDetails.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 02/07/24.
//

import SwiftUI
import MapKit
struct CityDetailView: View {
    @ObservedObject var viewModel: HomeViewModel
    var place: Place
    @State private var showFullDescription = false
    @State private var isFavorite: Bool
    @State private var userRating: Double
    @State private var showRatingSheet = false
    @State private var localLikes: Int
    @State private var localRating: Double
    
    init(viewModel: HomeViewModel, place: Place) {
        self.viewModel = viewModel
        self.place = place
        _isFavorite = State(initialValue: viewModel.isPlaceFavorite(place))
        _userRating = State(initialValue: viewModel.getUserRating(for: place))
        _localLikes = State(initialValue: place.nLikes)
        _localRating = State(initialValue: place.rating)
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                heroImage
                
                VStack(alignment: .leading, spacing: 15) {
                    cityInfo
                    ratingView
                    descriptionView
                    mapView
                    weatherInfo
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showRatingSheet) {
            RatingView(rating: $userRating, isPresented: $showRatingSheet) {
                updateLikeAndRating()
            }
        }
    }
    
    private var heroImage: some View {
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
    }
    
    private var cityInfo: some View {
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
            
            Text("\(localLikes)")
                .font(.subheadline)
                .fontWeight(.semibold)
            Button(action: toggleFavorite) {
                Image(systemName: isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(isFavorite ? .red : .gray)
                    .font(.title2)
            }
        }
    }
    
    private var ratingView: some View {
        HStack {
            ForEach(0..<5) { index in
                Image(systemName: index < Int(localRating) ? "star.fill" : "star")
                    .foregroundColor(.yellow)
            }
            Text(String(format: "%.1f", localRating))
                .fontWeight(.semibold)
            
            Spacer()
            
            Button(action: { showRatingSheet = true }) {
                Text("Valuta")
                    .font(.subheadline)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
    }
    
    private var descriptionView: some View {
        VStack(alignment: .leading) {
            Text("\(place.description)")
                .lineLimit(showFullDescription ? nil : 3)
                .font(.body)
            
            Button(action: { showFullDescription.toggle() }) {
                Text(showFullDescription ? "Leggi meno" : "Leggi di più")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var mapView: some View {
        let coordinate = CLLocationCoordinate2D(latitude: place.latitude, longitude: place.longitude)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        
        return Map(coordinateRegion: .constant(region), annotationItems: [place]) { place in
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
    }
    
    private var weatherInfo: some View {
        HStack {
            Image(systemName: "sun.max.fill")
                .foregroundColor(.yellow)
            Text("25°C")
            Spacer()
            Text("Soleggiato")
        }
        .padding()
        .background(Color.blue.opacity(0.1))
        .cornerRadius(8)
    }
    
    private func toggleFavorite() {
        isFavorite.toggle()
        viewModel.toggleFavorite(for: place)
        localLikes = viewModel.getUpdatedLikes(for: place)
    }
    
    private func updateLikeAndRating() {
        viewModel.updateLikeAndRating(for: place, newRating: userRating)
        localRating = viewModel.getUpdatedRating(for: place)
        localLikes = viewModel.getUpdatedLikes(for: place)
        isFavorite = viewModel.isPlaceFavorite(place)
    }
}

struct RatingView: View {
    @Binding var rating: Double
    @Binding var isPresented: Bool
    var onSubmit: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Valuta questo posto")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack(spacing: 15) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                        .font(.title)
                        .foregroundColor(.yellow)
                        .onTapGesture {
                            rating = Double(index)
                        }
                }
            }
            
            Text(String(format: "%.1f stelle", rating))
                .font(.headline)
            
            Slider(value: $rating, in: 1...5, step: 0.5)
                .accentColor(.yellow)
            
            HStack(spacing: 20) {
                Button("Annulla") {
                    isPresented = false
                }
                .foregroundColor(.red)
                .padding()
                .background(Color.red.opacity(0.1))
                .cornerRadius(10)
                
                Button("Invia") {
                    onSubmit()
                    isPresented = false
                }
                .foregroundColor(.white)
                .padding()
                .background(Color.orange)
                .cornerRadius(10)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 10)
    }
}

#Preview {
    let viewModel = HomeViewModel()
    let place = Place(id: "30ie", name: "Le 5 Terre", country: "Italia", region: "Liguria", rating: 4.5, imageUrl: "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg", latitude: 44.1461, longitude: 9.6439, nLikes: 384, description: "Test description")
    return CityDetailView(viewModel: viewModel, place: place)
}
