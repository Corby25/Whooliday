import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesModel = FavoritesModel()
    @State private var selectedTab = 0 // 0: Hotels, 1: Filters

    var body: some View {
        NavigationView {
            VStack {
                Picker(selection: $selectedTab, label: Text("Select")) {
                    Text("Hotels").tag(0)
                    Text("Places").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal) // Only add horizontal padding
                .padding(.vertical, 8) // Reduce vertical padding

                if selectedTab == 0 {
                    // Display main hotels list with deletion enabled and filtering deleted hotels
                    HotelsListView(hotels: favoritesModel.hotels, favoritesModel: favoritesModel, isMain: true)
                } else {
                    // Display filters list
                    FiltersListView(favoritesModel: favoritesModel)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}


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
                }
                .if(isMain) {
                    $0.onDelete(perform: deleteHotel)
                }
            }
        }
        .if(isMain) { view in
            view.refreshable {
                await favoritesModel.refreshHotels()
            }
        }
        /*
        .sheet(item: $selectedHotel) { listing in
            ListingDetailView(listing: listing, viewModel: viewModel)
        }
         */
    }

    private func deleteHotel(at offsets: IndexSet) {
        for index in offsets {
            let hotel = hotels.filter { !$0.isDeleted }[index]
            favoritesModel.deleteHotel(hotel)
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

struct HotelRowView: View {
    var hotel: Hotel
    var isMain: Bool
    var favoritesModel: FavoritesModel
    @Binding var selectedHotel: Listing?
    
    var body: some View {
        Button(action: {
            selectedHotel = hotelToListing(hotel: hotel)
        }) {
            HStack {
                if let images = hotel.images, let firstImage = images.first, let url = URL(string: firstImage) {
                    AsyncImage(url: url) { image in
                        image.resizable()
                            .frame(width: 50, height: 50)
                            .cornerRadius(8)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 50, height: 50)
                    }
                } else {
                    Image("listing-1")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .cornerRadius(8)
                }

                VStack(alignment: .leading) {
                    Text(hotel.name ?? "Unknown Hotel")
                        .font(.headline)
                        .foregroundColor(.black)

                    if hotel.isNew {
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
                Spacer()
                if hotel.isNew {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
            }
        }
    }

    private func hotelToListing(hotel: Hotel) -> Listing {
        return Listing(
            id: Int(hotel.hotelID) ?? 0,
            latitude: 0.0,
            longitude: 0.0,
            city: "",
            state: "",
            name: hotel.name ?? "Unknown Hotel",
            strikethrough_price: hotel.isNew ? hotel.oldPrice : 0.0,
            review_count: hotel.reviewCount ?? 0,
            review_score: hotel.reviewScore ?? 0.0,
            checkin: "",
            checkout: "",
            nAdults: 0,
            nChildren: 0,
            childrenAge: "",
            currency: "",
            images: hotel.images ?? []
            
        )
    }

    private func deleteHotel(_ hotel: Hotel) {
        favoritesModel.deleteHotel(hotel)
    }
}

struct FiltersListView: View {
    @ObservedObject var favoritesModel: FavoritesModel
    @State private var selectedFilter: Filter?
    
    var body: some View {
        List {
            ForEach(favoritesModel.filters.filter { !$0.isDeleted }) { filter in
                NavigationLink(
                    destination: FilterHotelsListView(filter: filter, favoritesModel: favoritesModel),
                    tag: filter.id ?? "",
                    selection: Binding(
                        get: { self.selectedFilter?.id },
                        set: { newValue in
                            self.selectedFilter = favoritesModel.filters.first(where: { $0.id == newValue })
                        }
                    )
                ) {
                    VStack(alignment: .leading) {
                        Text("Max Price: \(filter.maxPrice)")
                        Text("Adults Number: \(filter.adultsNumber)")
                        Text("Latitude: \(filter.latitude)")
                        Text("Longitude: \(filter.longitude)")
                        Text("Order By: \(filter.orderBy)")
                        Text("Room Number: \(filter.roomNumber)")
                        Text("Units: \(filter.units)")
                        Text("Check In: \(filter.checkIn)")
                        Text("Check Out: \(filter.checkOut)")
                        Text("Children Number: \(filter.childrenNumber)")
                        Text("Children Age: \(filter.childrenAge)")
                    }
                }
            }
            .onDelete(perform: deleteFilters)
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
