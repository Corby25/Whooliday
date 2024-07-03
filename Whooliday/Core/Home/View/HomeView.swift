//
//  HomeView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel: HomeViewModel
    @State private var searchParameters = SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges: [])
    @State private var showDestinationSearch = false
    @State private var navigateToExplore = false
    @State private var selectedPlace: Place? = nil
    @State private var showAddFilterView = false
    
    init(viewModel: HomeViewModel = HomeViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                headerView
                
                SearchAndFilterBar(showFilterView: $showAddFilterView, isFavorite: .constant(false), onFavoriteToggle: {}, showFilterAndFavorite: false)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDestinationSearch = true
                        }
                    }
                
                ContinentButtons(selectedContinent: $viewModel.selectedContinent, viewModel: viewModel)
                
                ScrollView {
                    createCards()
                }
                .scrollIndicators(.hidden)
            }
            .padding()
            .overlay(DestinationSearchOverlay(showDestinationSearch: $showDestinationSearch,
                                              searchParameters: $searchParameters,
                                              navigateToExplore: $navigateToExplore))
            .navigationDestination(isPresented: $navigateToExplore) {
                ExploreView(searchParameters: searchParameters)
            }
            .sheet(item: $selectedPlace) { place in
                CityDetailView(viewModel: viewModel, place: place)
            }
            .onAppear {
                viewModel.fetchPlaces()
            }
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Cerca il tuo Hotel")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Partendo da qui")
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Image("logo2")
                .resizable()
                .frame(width: 70, height: 70)
        }
    }
    
    private func createCards() -> some View {
        VStack(spacing: 20) {
            if !viewModel.places.isEmpty {
                CardViewBig(place: viewModel.places[0])
                    .onTapGesture {
                        selectedPlace = viewModel.places[0]
                    }
                
                ForEach(0..<(viewModel.places.count - 1) / 2, id: \.self) { rowIndex in
                    createCardRow(startingAt: rowIndex * 2 + 1)
                }
            }
        }
    }
    
    private func createCardRow(startingAt index: Int) -> some View {
        HStack(spacing: 15) {
            ForEach(0..<2) { columnIndex in
                let placeIndex = index + columnIndex
                if placeIndex < viewModel.places.count {
                    CardViewSmall(place: viewModel.places[placeIndex])
                        .onTapGesture {
                            selectedPlace = viewModel.places[placeIndex]
                        }
                } else {
                    Spacer()
                }
            }
        }
    }
}

struct ContinentButtons: View {
    @Binding var selectedContinent: String
    let viewModel: HomeViewModel
    
    let continent = ["Mondo", "Europa", "Asia", "Africa", "America", "Oceania", "Antartide"]
    let continentSymbol = [
        "Mondo": "globe.europe.africa.fill",
        "Europa": "building.fill",
        "Asia": "globe.asia.australia.fill",
        "Africa": "sun.horizon.fill",
        "America": "snowflake",
        "Oceania": "wave.3.forward",
        "Antartide": "snow",
    ]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(continent.enumerated()), id: \.element) { index, continent in
                    Button(action: {
                        selectedContinent = continent
                        viewModel.fetchPlaces()
                    }) {
                        HStack {
                            Image(systemName: String(continentSymbol[continent] ?? ""))
                            Text(continent)
                        }
                        .fontWeight(.semibold)
                        .frame(width: 120, height: 45)
                        .background(continent == selectedContinent ? Color.orange : Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 5)
        }
        .mask(
            HStack(spacing: 0) {
                LinearGradient(gradient: Gradient(colors: [.clear, .black, .black]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 30)
                
                Rectangle().fill(Color.black)
                
                LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .leading, endPoint: .trailing)
                    .frame(width: 30)
            })
    }
}

struct DestinationSearchOverlay: View {
    @Binding var showDestinationSearch: Bool
    @Binding var searchParameters: SearchParameters
    @Binding var navigateToExplore: Bool
    
    var body: some View {
        ZStack {
            if showDestinationSearch {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showDestinationSearch = false
                        }
                    }
                
                DestinationSearchView(searchParameters: $searchParameters,
                                      show: $showDestinationSearch,
                                      navigateToExplore: $navigateToExplore)
                    .transition(.move(edge: .bottom))
                    .background(Color.white)
                    .cornerRadius(25)
                    .padding()
            }
        }
    }
}

extension HomeViewModel {
    static func mock() -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.places = [
            Place(id: "30ie", name: "Le 5 Terre", country: "Italia", region: "Liguria", rating: 4.5, imageUrl: "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg", latitude: 0.0, longitude: 0.0, nLikes: 121, description: "Test description"),
            Place(id: "eif9", name: "Roma", country: "Italia", region: "Lazio", rating: 4.9, imageUrl: "https://wallpapercave.com/wp/wp1826245.jpg", latitude: 0.0, longitude: 0.0, nLikes: 23, description: "Test description"),
            Place(id: "e3i0", name: "Parigi", country: "Francia", region: "Île-de-France", rating: 4.7, imageUrl: "https://img.freepik.com/premium-photo/background-paris_219717-5461.jpg", latitude: 0.0, longitude: 0.0, nLikes: 44, description: "Test description"),
            Place(id: "kd0jf", name: "Londra", country: "Regno Unito", region: "Inghilterra", rating: 4.6, imageUrl: "https://i.etsystatic.com/29318579/r/il/805ae0/3339810438/il_fullxfull.3339810438_4t71.jpg", latitude: 0.0, longitude: 0.0, nLikes: 564, description: "Test description"),
            Place(id: "di03", name: "Londra", country: "Regno Unito", region: "Inghilterra", rating: 4.6, imageUrl: "https://i.etsystatic.com/29318579/r/il/805ae0/3339810438/il_fullxfull.3339810438_4t71.jpg", latitude: 0.0, longitude: 0.0, nLikes: 54, description: "Test description")
        ]
        viewModel.selectedContinent = "Mondo"
        return viewModel
    }
}

#Preview {
    HomeView(viewModel: HomeViewModel.mock())
}