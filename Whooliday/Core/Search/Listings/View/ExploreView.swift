//
//  ExploreView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//
import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    @State private var searchParameters: SearchParameters
    @State private var showDestinationSearchView = false
    @State private var hasPerformedSearch = false
    @State private var showCompactView = false
    @State private var appliedFilters: String = ""
    @State private var showAddFilterView = false

    init(searchParameters: SearchParameters) {
        self._viewModel = StateObject(wrappedValue: ExploreViewModel(service: ExploreService()))
        self._searchParameters = State(initialValue: searchParameters)
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    ScrollView {
                        SearchAndFilterBar()
                            .onTapGesture {
                                withAnimation(.snappy) {
                                    showDestinationSearchView.toggle()
                                }
                            }
                        
                        FilterView()
                            .onTapGesture {
                                showAddFilterView = true
                            }
                        
                        
                        LazyVStack(spacing: 32) {
                            ForEach(viewModel.listings) { listing in
                                NavigationLink(destination: ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))) {
                                    if showCompactView {
                                        CompactListingView(listing: listing)
                                    } else {
                                        ListingItemView(listing: listing)
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
                
                if viewModel.isLoading {
                    LoadingView(isPresented: $viewModel.isLoading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.white)
                        .edgesIgnoringSafeArea(.all)
                }
            }
          
            .overlay(
                ZStack {
                    if showDestinationSearchView {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.spring()) {
                                    showDestinationSearchView = false
                                }
                            }
                        
                        DestinationSearchView(searchParameters: $searchParameters, show: $showDestinationSearchView, navigateToExplore: .constant(false))
                            .transition(.move(edge: .bottom))
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding()
                    }
                    
                    if showAddFilterView {
                        AddFilterView(show: $showAddFilterView, appliedFilters: $appliedFilters)
                            .transition(.move(edge: .bottom))
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding()
                    }
                }
            )
        }
        .onAppear {
            performSearch()
        }
        .onChange(of: appliedFilters) { oldValue, newValue in
            print("Applied filters changed from: \(oldValue) to: \(newValue)")
            performSearch()
        }
        .onChange(of: searchParameters) { _ in
            performSearch()
        }
    }

    private func performSearch() {
        var updatedParameters = searchParameters
        updatedParameters.filters = appliedFilters
        viewModel.fetchListings(with: updatedParameters)
        hasPerformedSearch = true
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExploreViewModel(service: MockExploreService())
        let searchParameters = SearchParameters(destination: "Rome", placeID: "C", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), numAdults: 2, numChildren: 0, childrenAges:[])
        return ExploreView(searchParameters: searchParameters)
    }
}
