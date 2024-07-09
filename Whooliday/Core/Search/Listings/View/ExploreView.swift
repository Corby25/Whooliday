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
    @State private var isFavorite: Bool = false
    @State private var selectedPropertyType: String = "Tutto"
    @State private var selectedTypeID: Int = 0 // Default to 0 for "Tutto"
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedSorting: SortOption = .none
    
    enum SortOption: String, CaseIterable {
        case none = "Nessun ordine"
        case priceAscending = "Prezzo crescente"
        case priceDescending = "Prezzo decrescente"
        case ratingDescending = "Valutazione decrescente"
        
        var iconName: String {
            switch self {
            case .none:
                return "arrow.up.arrow.down"
            case .priceAscending:
                return "arrow.up.circle"
            case .priceDescending:
                return "arrow.down.circle"
            case .ratingDescending:
                return "star.fill"
            }
        }
    }
    
    @State private var listingsByType: [Listing] = []
    
    private let firebaseManager = FirebaseManager.shared

    init(searchParameters: SearchParameters) {
        self._viewModel = StateObject(wrappedValue: ExploreViewModel(service: ExploreService()))
        self._searchParameters = State(initialValue: searchParameters)
        
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    SearchAndFilterBar(showFilterView: $showAddFilterView, isFavorite: $isFavorite, onFavoriteToggle: toggleFavorite, showFilterAndFavorite: true)
                        .onTapGesture {
                            withAnimation(.snappy) {
                                showDestinationSearchView.toggle()
                            }
                        }
                    
                    FilterView(selectedPropertyType: $selectedPropertyType, selectedTypeID: $selectedTypeID)
                    
                    ScrollView {
                        LazyVStack(spacing: 32) {
                            ForEach(listingsByType.isEmpty ? viewModel.listings : listingsByType) { listing in
                                NavigationLink(destination: ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))) {
                                        ListingItemView(listing: listing)
                                            .frame(height: 300)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                }
                                .foregroundColor(colorScheme == .dark ? .white : .black)
                            }
                        }
                    }.id(UUID())
                    
                        .overlay(
                            VStack {
                                Spacer()
                                Picker("Ordina per", selection: $selectedSorting) {
                                    ForEach(SortOption.allCases, id: \.self) { option in
                                        Image(systemName: option.iconName)
                                            .tag(option)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                                .padding(.horizontal, 60)
                                .padding(.bottom, 16)
                                .background(Color(UIColor.systemBackground)) // Colore adattabile alla modalità
                            }
                        )

                }
                
                if viewModel.isLoading {
                    LoadingView(isPresented: $viewModel.isLoading)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(colorScheme == .dark ? .black : .white)
                        .edgesIgnoringSafeArea(.all)
                }
            }
            .navigationBarHidden(hasPerformedSearch)
            
            .overlay(
                ZStack() {
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
                           
                            .cornerRadius(16)
                            .padding()
                    }
                    
                    if showAddFilterView {
                        AddFilterView(show: $showAddFilterView, appliedFilters: $appliedFilters) {
                            performSearch()
                        }
                        .transition(.move(edge: .bottom))
                        .background(colorScheme == .dark ? .black : .white)
                        .cornerRadius(16)
                        .padding()
                    }
                }
            )
        }
        .onChange(of: selectedSorting) { _, _ in
            sortListings()
        }
        .onAppear {
            if(!hasPerformedSearch){
                performSearch()
            }
        }
        .onChange(of: appliedFilters) { oldValue, newValue in
            print("Applied filters changed from: \(oldValue) to: \(newValue)")
            performSearch()
        }
        .onChange(of: searchParameters) { oldValue, newValue in
            performSearch()
        }
        .onChange(of: selectedPropertyType) { oldValue, newValue in
            Task {
                await performSearchType()
            }
        }
    }
    
    private func sortListings() {
        let listingsToSort = listingsByType.isEmpty ? viewModel.listings : listingsByType
        
        switch selectedSorting {
        case .priceAscending:
            let sortedListings = listingsToSort.sorted { $0.price < $1.price }
            updateListings(sortedListings)
        case .priceDescending:
            let sortedListings = listingsToSort.sorted { $0.price > $1.price }
            updateListings(sortedListings)
        case .ratingDescending:
            let sortedListings = listingsToSort.sorted { $0.review_score > $1.review_score }
            updateListings(sortedListings)
        case .none:
            updateListings(viewModel.listings)
        }
    }

    private func updateListings(_ sortedListings: [Listing]) {
        DispatchQueue.main.async {
            self.listingsByType = sortedListings
            self.viewModel.listings = sortedListings
        }
    }
    private func performSearch() {
        var updatedParameters = searchParameters
        updatedParameters.filters = appliedFilters
        updatedParameters.propertyType = selectedPropertyType
        viewModel.fetchListings(with: updatedParameters)
        hasPerformedSearch = true
    }
    
    private func performSearchType() async {
        viewModel.isLoading = true
        let filteredListings = await withTaskGroup(of: (Listing, Bool).self) { group in
            for listing in viewModel.listings {
                group.addTask {
                    let isMatch = try? await self.viewModel.fetchHotelType(listing: listing, accomodationType: self.selectedTypeID)
                    return (listing, isMatch ?? false)
                }
            }
            
            var result: [Listing] = []
            for await (listing, isMatch) in group {
                if isMatch {
                    result.append(listing)
                }
            }
            viewModel.isLoading = false
            return result
            
        }
        
        DispatchQueue.main.async {
            self.listingsByType = filteredListings
        }
        
    }
    
    
  
    
    private func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            saveSearch()
        } else {
            removeSearch()
        }
    }

    private func saveSearch() {
           
           
           if let firstListing = viewModel.listings.first {
               firebaseManager.addFavoriteFilter(listing: firstListing, appliedFilters: appliedFilters, listings: viewModel.listings)
               print("Ricerca salvata")
           } else {
               print("No listings available to save as favorite filter")
           }
       }
       
       private func removeSearch() {
           // Implementa la logica per rimuovere la ricerca dai preferiti
           print("Ricerca rimossa dai preferiti")
           // You might want to implement a method to remove the favorite filter from Firebase
       }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExploreViewModel(service: MockExploreService())
        let searchParameters = SearchParameters(destination: "Rome", placeID: "C", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), numAdults: 2, numChildren: 0, childrenAges:[])
        return ExploreView(searchParameters: searchParameters)
    }
}
