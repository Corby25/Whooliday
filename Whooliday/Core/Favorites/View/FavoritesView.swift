import SwiftUI

// view for the favorites page of the app
struct FavoritesView: View {
    @StateObject private var favoritesModel = FavoritesModel()
    @State private var selectedTab = 0 // 0: Hotels, 1: Filters
    
    // header with some graphic to present the page
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(NSLocalizedString("Discover deals", comment: ""))
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(NSLocalizedString("Select an hotel or filter", comment: ""))
                    .font(.title2)
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Image("logo2")
                .resizable()
                .frame(width: 70, height: 70)
        }
        .padding()
    }
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                // picker to show either the hotels or the filter list
                Picker(selection: $selectedTab, label: Text("Select")) {
                    Text(NSLocalizedString("Hotels", comment: "")).tag(0)
                    Text(NSLocalizedString("Places", comment: "")).tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if selectedTab == 0 {
                    // Display main hotels list with deletion enabled and filtering deleted hotels
                    HotelsListView(hotels: favoritesModel.hotels, favoritesModel: favoritesModel, isMain: true)
                } else {
                    // Display filters list
                    FiltersListView(favoritesModel: favoritesModel)
                }
            }
            .navigationBarHidden(true) // Hide the default navigation title
        }
    }
}

// view to show the list of the hotels. While loading it shows a dummy list with the shimmering effect.
// once loaded it shows the actual hotels list and once an hotel is clicked it redirects to the ListingDetailView
struct HotelsListView: View {
    @State private var selectedHotel: Listing?
    var hotels: [Hotel]
    @ObservedObject var favoritesModel: FavoritesModel
    var isMain: Bool
    @StateObject var viewModel = ExploreViewModel(service: ExploreService())
    
    var body: some View {
        List {
            if favoritesModel.isLoadingHotels {
                ForEach(dummyHotels) { hotel in
                    HotelRowView(hotel: hotel, isMain: isMain, favoritesModel: favoritesModel, selectedHotel: $selectedHotel)
                        .shimmering()
                }
            } else {
                ForEach(hotels.filter { !$0.isDeleted }) { hotel in
                    HotelRowView(hotel: hotel, isMain: isMain, favoritesModel: favoritesModel, selectedHotel: $selectedHotel)
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            if isMain {
                                if hotel.isNew {
                                    Button {
                                        favoritesModel.makeHotelAsSeen(hotel)
                                    } label: {
                                        Label(NSLocalizedString("Visualize", comment: ""), systemImage: "eye")
                                    }
                                    .tint(.blue)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            if isMain {
                                Button(role: .destructive) {
                                    favoritesModel.deleteHotel(hotel)
                                } label: {
                                    Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                                }
                            }
                        }
                }
            }
        }
        .if(isMain) { view in
            view.refreshable {
                await favoritesModel.refreshHotels()
            }
        }
        .sheet(item: $selectedHotel) { listing in
            ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))
        }
        
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

// single element of the hotels list, it shows some infos about the hotel
struct HotelRowView: View {
    var hotel: Hotel
    var isMain: Bool
    var favoritesModel: FavoritesModel
    @Binding var selectedHotel: Listing?
    
    var body: some View {
        Button(action: {
            selectedHotel = hotelToListing(hotel: hotel)
        }) {
            ZStack {
                HStack {
                    if let images = hotel.images, let firstImage = images.first, let url = URL(string: firstImage) {
                        AsyncImage(url: url) { image in
                            image.resizable()
                                .frame(width: 60, height: 50)
                                .cornerRadius(8)
                        } placeholder: {
                            ProgressView()
                                .frame(width: 60, height: 50)
                        }
                    } else {
                        Image("listing-1")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .cornerRadius(8)
                    }
                    Spacer()
                    VStack(alignment: .leading) {
                        Text(hotel.name ?? "Unknown Hotel")
                            .font(.headline)
                            .lineLimit(1)
                        
                        Text("\(hotel.city ?? "City")")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(NSLocalizedString("From:", comment: "Check-in date label prefix") + " " + hotel.checkIn)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(NSLocalizedString("A:", comment: "") + " " + hotel.checkOut)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        if let childrenNumber = hotel.childrenNumber {
                            Text(NSLocalizedString("Guest number:", comment: "") + " " + "\(hotel.adultsNumber + childrenNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text(NSLocalizedString("Guest number:", comment: "") + " " + "\(hotel.adultsNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if hotel.newPrice == 0 {
                            Text(NSLocalizedString("Sold Out", comment: ""))
                                .font(.subheadline)
                            
                        } else if hotel.newPrice != hotel.oldPrice {
                            Text("€\(hotel.oldPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .strikethrough(true, color: .red)
                            Text("€\(hotel.newPrice, specifier: "%.2f")")
                                .font(.subheadline)
                            
                        } else {
                            Text("€\(hotel.newPrice, specifier: "%.2f")")
                                .font(.subheadline)
                            
                        }
                    }
                    if hotel.isNew {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 10, height: 10)
                    }
                }
                if hotel.newPrice == 0 {
                    Image("sold-out")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: 160, maxHeight: 200)
                        .opacity(0.4)
                }
            }
            
            .cornerRadius(10)
        }
    }
    
    // transform an hotel struct to Listing one
    private func hotelToListing(hotel: Hotel) -> Listing {
        return Listing(
            id: Int(hotel.hotelID) ?? 0,
            latitude: hotel.latitude ?? 0.0,
            longitude: hotel.longitude ?? 0.0,
            city: hotel.city ?? "Unknown City",
            state: hotel.state ?? "Unknown State",
            name: hotel.name ?? "Unknown Hotel",
            strikethrough_price: hotel.isNew ? hotel.oldPrice : 0.0,
            review_count: hotel.reviewCount ?? 0,
            review_score: hotel.reviewScore ?? 0.0,
            checkin: hotel.checkIn,
            checkout: hotel.checkOut,
            nAdults: hotel.adultsNumber,
            nChildren: hotel.childrenNumber,
            childrenAge: hotel.childrenAge,
            currency: favoritesModel.userCurrency,
            images: hotel.images ?? []
            
        )
    }
    
    private func deleteHotel(_ hotel: Hotel) {
        favoritesModel.deleteHotel(hotel)
    }
}

// view to show the list of the filters
struct FiltersListView: View {
    @ObservedObject var favoritesModel: FavoritesModel
    @State private var selectedFilter: Filter?
    
    let colors: [Color] = [.blue, .green, .orange, .purple, .pink]
    
    var body: some View {
        List {
            ForEach(Array(favoritesModel.filters.filter { !$0.isDeleted }.enumerated()), id: \.element.id) { index, filter in
                NavigationLink(
                    destination: FilterHotelsListView(filter: filter, favoritesModel: favoritesModel),
                    tag: filter.id ?? "",
                    selection: Binding(
                        get: { self.selectedFilter?.id },
                        set: { newValue in
                            self.selectedFilter = favoritesModel.filters.first(where: { $0.id == newValue })
                            /*if let id = filter.id {
                             favoritesModel.markFilterAsNotNew(withId: id)
                             }*/
                        }
                    )
                ) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(colors[index % colors.count])
                                .frame(width: 30, height: 30)
                            
                            Text("\(index + 1)")
                            
                                .font(.headline)
                        }
                        .padding(.leading, -5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text(NSLocalizedString("From:", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(filter.checkIn)
                                    .font(.subheadline)
                                Text(NSLocalizedString("To:", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading,1)
                                Text(filter.checkOut)
                                    .font(.subheadline)
                            }
                            HStack {
                                Text(NSLocalizedString("Max price:", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                
                                if filter.maxPrice == 0 {
                                    Text(NSLocalizedString("Not selected", comment: ""))
                                        .font(.subheadline)
                                } else {
                                    Text("\(filter.maxPrice, specifier: "%.2f") \(favoritesModel.userCurrency)")
                                        .font(.subheadline)
                                }
                            }
                            HStack {
                                Text(NSLocalizedString("Guest number:", comment: ""))
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(filter.adultsNumber + filter.childrenNumber)")
                                    .font(.subheadline)
                            }
                            HStack {
                                Text(NSLocalizedString("Where:", comment: ""))
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                                Text("\(filter.city)")
                                    .font(.subheadline)
                            }
                        }
                        if filter.isNew {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 10, height: 10)
                                .padding(.trailing, 10)
                        }
                    }
                }
                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                    if filter.isNew {
                        Button {
                            if let id = filter.id {
                                favoritesModel.markFilterAsNotNew(withId: id)
                            }
                        } label: {
                            Label(NSLocalizedString("Visualize", comment: ""), systemImage: "eye")
                        }
                        .tint(.blue)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        if let id = filter.id {
                            favoritesModel.deleteFilter(withId: id)
                        }
                    } label: {
                        Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                    }
                }
            }
        }
        .refreshable {
            await favoritesModel.refreshFilters()
        }
    }
    
    private func deleteFilters(at offsets: IndexSet) {
        let filtersToDelete = offsets.map { favoritesModel.filters[$0] }
        
        for filter in filtersToDelete {
            if let id = filter.id {
                favoritesModel.deleteFilter(withId: id)
            }
        }
    }
}

// view to handle the loading and the display of the hotels inside a filter
struct FilterHotelsListView: View {
    let filter: Filter
    @ObservedObject var favoritesModel: FavoritesModel
    @State private var localHotels: [Hotel] = []
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                List {
                    ForEach(dummyHotels) { hotel in
                        HotelRowView(hotel: hotel, isMain: false, favoritesModel: favoritesModel, selectedHotel: .constant(nil))
                            .shimmering()
                    }
                }
            } else {
                HotelsListView(hotels: localHotels, favoritesModel: favoritesModel, isMain: false)
            }
        }
        .onAppear {
            isLoading = true
            Task {
                await favoritesModel.fetchHotelsForFilter(filter)
                DispatchQueue.main.async {
                    if let updatedFilter = favoritesModel.filters.first(where: { $0.id == filter.id }) {
                        localHotels = updatedFilter.hotels
                    }
                    isLoading = false
                }
            }
        }
    }
}

