//
//  FavoriteView1.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 30/06/24.
//

import SwiftUI


struct FavoriteView1: View {
    @StateObject private var viewModel = FavoriteModel1()
    @State private var showCompactView = false

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    LoadingView(isPresented: $viewModel.isLoading)
                } else if $viewModel.favoriteListings.isEmpty {
                    Text("Non hai ancora aggiunto hotel ai preferiti")
                        .font(.headline)
                        .foregroundColor(.gray)
                } else {
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.favoriteListings) { listing in
                                NavigationLink(destination: ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))) {
                                    if showCompactView {
                                        CompactListingView(listing: listing)
                                    } else {
                                        
                                        ListingFavoriteView(listing: listing)
                                            .frame(height: 300)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                }
                                .foregroundColor(.black)
                            }
                        }
                    }

                    Picker("View Style", selection: $showCompactView) {
                        Image(systemName: "square.grid.2x2").tag(false)
                        Image(systemName: "list.bullet").tag(true)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .padding(.horizontal, 90)
                }
            }
            .navigationTitle("I tuoi Preferiti")
        }
        .onAppear {
            viewModel.fetchFavoriteListings()
        }
    }
}

#Preview {
    FavoriteView1()
}
