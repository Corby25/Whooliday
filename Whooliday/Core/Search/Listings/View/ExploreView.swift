//
//  ExploreView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI

struct ExploreView: View {
    @StateObject var viewModel: ExploreViewModel
    @State var searchParameters: SearchParameters
    @State private var showDestinationSearchView = false
    @State var hasPerformedSearch = false
    @State private var showCompactView = false
    @State private var appliedFilters: String = ""
    @State private var showAddFilterView = false
    @State var isFavorite: Bool = false
    @State var selectedPropertyType: String = "Tutto"
    @State var selectedTypeID: Int = 0 // Default to 0 for "Tutto"
    @Environment(\.colorScheme) var colorScheme
    @State var selectedSorting: SortOption = .none
    @Environment(\.presentationMode) var presentationMode
    @State private var filterViewOffset: CGFloat = UIScreen.main.bounds.height
    
    enum SortOption: String, CaseIterable {
        case none = "Nessun ordine"
        case priceAscending = "Prezzo crescente"
        case priceDescending = "Prezzo decrescente"
        case ratingDescending = "Valutazione decrescente"
        
        var iconName: String {
            switch self {
            case .none: return "arrow.up.arrow.down"
            case .priceAscending: return "arrow.up.circle"
            case .priceDescending: return "arrow.down.circle"
            case .ratingDescending: return "star.fill"
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
                mainContent
                loadingOverlay
            }
            .navigationBarHidden(hasPerformedSearch)
            .overlay(searchAndFilterOverlay)
            .gesture(
                DragGesture()
                    .onEnded { gesture in
                        if gesture.translation.width > 100 {
                            handleSwipe(translation: gesture.translation.width)
                        }
                    }
            )
            .overlay(
                backButton,
                alignment: .topLeading
            )
        }
        .onChange(of: selectedSorting) { _, _ in
            sortListings()
        }
        .onAppear {
            if (!hasPerformedSearch) {
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
    
    private var backButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.primary)
                .padding()
                .fontWeight(.bold)
        }
        .padding(.top, 20)
        .padding(.leading, 20)
        .edgesIgnoringSafeArea(.top)
    }
    
    private var mainContent: some View {
        VStack(spacing: 0) {
            searchAndFilterBar
            filterView
            listingsScrollView
        }
    }
    
    private var searchAndFilterBar: some View {
        SearchAndFilterBar(showFilterView: $showAddFilterView, isFavorite: $isFavorite, onFavoriteToggle: toggleFavorite, showFilterAndFavorite: true)
            .onTapGesture {
                withAnimation(.snappy) {
                    showDestinationSearchView.toggle()
                }
            }
            .onChange(of: showAddFilterView) { newValue in
                withAnimation(.spring(response: 0.5, dampingFraction: 0.65, blendDuration: 0)) {
                    showAddFilterView = newValue
                    filterViewOffset = newValue ? 0 : UIScreen.main.bounds.height
                }
            }
    }
    
    private var filterView: some View {
        FilterView(selectedPropertyType: $selectedPropertyType, selectedTypeID: $selectedTypeID)
    }
    
    private var listingsScrollView: some View {
        ScrollView {
            LazyVStack(spacing: 32) {
                ForEach(listingsByType.isEmpty ? viewModel.listings : listingsByType) { listing in
                    listingNavigationLink(for: listing)
                }
            }
        }
        .id(UUID())
        .overlay(sortingPicker)
    }
    
    private func listingNavigationLink(for listing: Listing) -> some View {
        NavigationLink(destination: ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))) {
            ListingItemView(listing: listing)
                .frame(height: 300)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        .foregroundColor(colorScheme == .dark ? .white : .black)
    }
    
    private var sortingPicker: some View {
        VStack {
            Spacer()
            Picker("Ordina per", selection: $selectedSorting) {
                ForEach(SortOption.allCases, id: \.self) { option in
                    Image(systemName: option.iconName)
                        .tag(option)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .background(colorScheme == .dark ? Color.black : Color.white)
            .frame(width: 260, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var loadingOverlay: some View {
        Group {
            if viewModel.isLoading {
                LoadingView(isPresented: $viewModel.isLoading)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    private var searchAndFilterOverlay: some View {
        ZStack {
            if showDestinationSearchView {
                destinationSearchOverlay
            }
            
            if showAddFilterView {
                addFilterOverlay
                    .transition(.opacity)
            }
        }
    }
    
    private var destinationSearchOverlay: some View {
        ZStack {
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
    }
    
    private var addFilterOverlay: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .opacity(showAddFilterView ? 1 : 0)
                .animation(.easeInOut, value: showAddFilterView)
                .onTapGesture {
                    withAnimation(.spring()) {
                        showAddFilterView = false
                        filterViewOffset = UIScreen.main.bounds.height
                    }
                }
            
            AddFilterView(show: $showAddFilterView, appliedFilters: $appliedFilters) {
                performSearch()
            }
            .background(colorScheme == .dark ? Color.black : Color.white)
            .cornerRadius(16)
            .padding()
            .offset(y: filterViewOffset)
            .animation(.spring(response: 0.8, dampingFraction: 1, blendDuration: 0), value: filterViewOffset)
        }
        .zIndex(showAddFilterView ? 1 : 0)
    }
    
    func sortListings() {
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
    
    func performSearch() {
        var updatedParameters = searchParameters
        updatedParameters.filters = appliedFilters
        updatedParameters.propertyType = selectedPropertyType
        viewModel.fetchListings(with: updatedParameters)
        hasPerformedSearch = true
    }
    
    func getIsFavorite() -> Bool {
        return self.isFavorite
    }
    
    func performSearchType() async {
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
    
    func toggleFavorite() {
        isFavorite.toggle()
        if isFavorite {
            saveSearch()
        } else {
            removeSearch()
        }
    }
    
    func saveSearch() {
        if let firstListing = viewModel.listings.first {
            firebaseManager.addFavoriteFilter(listing: firstListing, appliedFilters: appliedFilters, listings: viewModel.listings)
            print("Ricerca salvata")
        } else {
            print("No listings available to save as favorite filter")
        }
    }
    
    private func removeSearch() {
        print("Ricerca rimossa dai preferiti")
        // You might want to implement a method to remove the favorite filter from Firebase
    }
    
    private func handleSwipe(translation: CGFloat) {
        if translation > 100 {
            presentationMode.wrappedValue.dismiss()
        }
    }
}

struct ExploreView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ExploreViewModel(service: MockExploreService())
        let searchParameters = SearchParameters(destination: "Rome", placeID: "C", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), numAdults: 2, numChildren: 0, childrenAges:[])
        return ExploreView(searchParameters: searchParameters)
    }
}
