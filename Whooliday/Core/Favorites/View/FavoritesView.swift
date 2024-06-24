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
                .padding()

                if selectedTab == 0 {
                    // Display main hotels list with deletion enabled and filtering deleted hotels
                    HotelsListView(hotels: favoritesModel.hotels, favoritesModel: favoritesModel, allowDeletion: true)
                } else {
                    // Display filters list
                    FiltersListView(filters: favoritesModel.filters, favoritesModel: favoritesModel)
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
    var allowDeletion: Bool
    
    var body: some View {
        List {
            if favoritesModel.isLoadingHotels {
                ForEach(dummyHotels, id: \.index) { hotel in
                    HotelRowView(hotel: hotel, allowDeletion: allowDeletion, favoritesModel: favoritesModel, selectedHotel: $selectedHotel)
                        .shimmering()
                }
            } else {
                ForEach(hotels.filter { !$0.isDeleted }) { hotel in
                    HotelRowView(hotel: hotel, allowDeletion: allowDeletion, favoritesModel: favoritesModel, selectedHotel: $selectedHotel)
                }
                .if(allowDeletion) {
                    $0.onDelete(perform: deleteHotel)
                }
            }
        }
        .sheet(item: $selectedHotel) { listing in
            ListingDetailView(listing: listing)
        }
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
    var allowDeletion: Bool
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
            name: hotel.name ?? "Unknown Hotel",
            strikethrough_price: hotel.isNew ? hotel.oldPrice : nil,
            review_count: hotel.reviewCount ?? 0,
            review_score: hotel.reviewScore ?? 0.0,
            images: hotel.images ?? []
        )
    }

    private func deleteHotel(_ hotel: Hotel) {
        favoritesModel.deleteHotel(hotel)
    }
}

struct FiltersListView: View {
    var filters: [Filter]
    @ObservedObject var favoritesModel: FavoritesModel
    @State private var selectedFilter: Filter?
    
    var body: some View {
        List {
            ForEach(filters.filter { !$0.isDeleted }) { filter in
                NavigationLink(
                    destination: FilterHotelsListView(filter: filter, favoritesModel: favoritesModel),
                    tag: filter,
                    selection: $selectedFilter
                ) {
                    VStack(alignment: .leading) {
                        Text("Max Price: \(filter.maxPrice)")
                        Text("Num Guests: \(filter.numGuests)")
                        Text("Latitude: \(filter.latitude)")
                        Text("Longitude: \(filter.longitude)")
                        Text("Adults Number: \(filter.adultsNumber)")
                        Text("Currency: \(filter.currency)")
                        Text("Locale: \(filter.locale)")
                        Text("Order By: \(filter.orderBy)")
                        Text("Room Number: \(filter.roomNumber)")
                        Text("Units: \(filter.units)")
                        Text("Check In: \(formattedDate(date: filter.checkIn))")
                        Text("Check Out: \(formattedDate(date: filter.checkOut))")
                    }
                }
            }
            .onDelete(perform: deleteFilters)

            /*.onDelete { indexSet in
                deleteFilters(at: indexSet)
            }*/
        }
    }
    private func deleteFilters(at offsets: IndexSet) {
        for index in offsets {
            favoritesModel.deleteFilter(at: index)
        }
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
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
                        ForEach(dummyHotels, id: \.index) { hotel in
                            HotelRowView(hotel: hotel, allowDeletion: false, favoritesModel: favoritesModel, selectedHotel: .constant(nil))
                                .shimmering()
                        }
                    }
                } else {
                    HotelsListView(hotels: localHotels, favoritesModel: favoritesModel, allowDeletion: false)
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



