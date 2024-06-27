//
//  ExploreView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel = ExploreViewModel(service: ExploreService())
    @State private var showDestinationSearchView = false
    @State private var searchParameters = SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges: [])
    @State private var hasPerformedSearch = false
    @State private var showCompactView = false
    
    var body: some View {
        NavigationStack {
            if showDestinationSearchView {
                DestinationSearchView(searchParameters: $searchParameters, show: $showDestinationSearchView)
                    .onDisappear {
                        if searchParameters.destination != "" {
                            viewModel.fetchListings(with: searchParameters)
                            hasPerformedSearch = true
                        }
                    }
            } else {
                ZStack {
                    VStack {
                        ScrollView {
                            SearchAndFilterBar()
                                .onTapGesture {
                                    withAnimation(.snappy) {
                                        showDestinationSearchView.toggle()
                                    }
                                }
                            
                            LazyVStack(spacing: 32) {
                                ForEach(viewModel.listings) { listing in
                                    NavigationLink(value: listing) {
                                        if showCompactView {
                                            CompactListingView(listing: listing)
                                        } else {
                                            ListingItemView(listing: listing)
                                                .frame(height: 400)
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
                    
                    if viewModel.isLoading {
                        LoadingView(isPresented: $viewModel.isLoading)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.white)
                            .edgesIgnoringSafeArea(.all)
                    }
                }
                
                .navigationDestination(for: Listing.self) { listing in
                    ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

#Preview("With Listings") {
    let viewModel = ExploreViewModel(service: MockExploreService())
    viewModel.fetchListings(with: SearchParameters(destination: "", placeID: "", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges:[]))
    return ExploreView(viewModel: viewModel)
}
