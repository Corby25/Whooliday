//
//  HomeView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    init(viewModel: HomeViewModel = HomeViewModel()) {
            _viewModel = StateObject(wrappedValue: viewModel)
        }
    @State private var searchParameters = SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges: [])
    
    @State private var showDestinationSearch = false
    
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
        
        VStack(alignment: .leading){
            HStack{
                VStack(alignment: .leading){
                    Text("Cerca il tuo Hotel")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    
                    
                    Text("Partendo da qui")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                }
                
                Spacer()
                
                Image("logo2")
                    .resizable()
                    .frame(width: 80, height: 80)
                
                
                
            }
            
            SearchAndFilterBar()
                .onTapGesture {
                    withAnimation(.spring()) {
                        showDestinationSearch = true
                    }
                }
                
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(Array(continent.enumerated()), id: \.element) { index, continent in
                        Button(action: {
                            viewModel.selectedContinent = continent
                            viewModel.fetchPlaces()
                        }) {
                            HStack {
                                Image(systemName: String(continentSymbol[continent] ?? ""))
                                Text(continent)
                            }
                            .fontWeight(.semibold)
                            .frame(width: 120, height: 45)
                            .background(continent == viewModel.selectedContinent ? Color.orange : Color.blue)
                            .foregroundColor(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                        }
                    }
                }
                .padding()
            }
            .mask(
                HStack(spacing: 0) {
                    LinearGradient(gradient: Gradient(colors: [.clear, .black, .black]), startPoint: .leading, endPoint: .trailing)
                        .frame(width: 30)
                    
                    Rectangle().fill(Color.black)
                    
                    LinearGradient(gradient: Gradient(colors: [.black, .black, .clear]), startPoint: .leading, endPoint: .trailing)
                        .frame(width: 30)
                })
            
            ScrollView {
                VStack(spacing: 20) {
                    if !viewModel.places.isEmpty {
                        CardViewBig(place: viewModel.places[0])
                        
                        ForEach(0..<(viewModel.places.count - 1) / 2, id: \.self) { rowIndex in
                            HStack(spacing: 15) {
                                ForEach(0..<2) { columnIndex in
                                    let index = rowIndex * 2 + columnIndex + 1
                                    if index < viewModel.places.count {
                                        CardViewSmall(place: viewModel.places[index])
                                    } else {
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                
            }
        }
        .padding()
        .overlay(
            ZStack {
                if showDestinationSearch {
                    Color.black.opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                showDestinationSearch = false
                            }
                        }
                    
                    DestinationSearchView(searchParameters: $searchParameters, show: $showDestinationSearch)
                        .transition(.move(edge: .bottom))
                        .background(Color.white)
                        .cornerRadius(16)
                        .padding()
                }
            }
        )
       
        
        
        .onAppear {
            viewModel.fetchPlaces()
        }
         
        
        
        
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}

extension HomeViewModel { 
    static func mock() -> HomeViewModel {
        let viewModel = HomeViewModel()
        viewModel.places = [
            Place(id: "30ie", name: "Le 5 Terre", country: "Italia", region: "Liguria", rating: 4.5, imageUrl: "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg"),
            
            Place(id: "eif9", name: "Roma", country: "Italia", region: "Lazio", rating: 4.9, imageUrl: "https://wallpapercave.com/wp/wp1826245.jpg"),
            
           
            
            Place(id: "e3i0", name: "Parigi", country: "Francia", region: "Île-de-France", rating: 4.7, imageUrl: "https://img.freepik.com/premium-photo/background-paris_219717-5461.jpg"),
            
            Place(id: "kd0jf", name: "Londra", country: "Regno Unito", region: "Inghilterra", rating: 4.6, imageUrl: "https://i.etsystatic.com/29318579/r/il/805ae0/3339810438/il_fullxfull.3339810438_4t71.jpg"),
            Place(id: "di03", name: "Londra", country: "Regno Unito", region: "Inghilterra", rating: 4.6, imageUrl: "https://i.etsystatic.com/29318579/r/il/805ae0/3339810438/il_fullxfull.3339810438_4t71.jpg")
        ]
        viewModel.selectedContinent = "world" 
        return viewModel
    }
}


#Preview("mock") {
    HomeView(viewModel: HomeViewModel.mock())
}

