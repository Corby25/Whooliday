import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesModel = FavoritesModel()
    @State private var selectedTab = 0 // 0: Hotels, 1: Filters
    
    /*private var hasNewHotels: Bool {
        return favoritesModel.hotels.contains(where: { $0.isNew })
    }
    
    private var hasNewFilters: Bool {
        return favoritesModel.filters.contains(where: { $0.hotels.contains(where: { $0.isNew }) })
    }*/

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

import SwiftUI

struct HotelsListView: View {
    @State private var selectedHotel: Listing?
    var hotels: [Hotel]
    var favoritesModel: FavoritesModel
    var allowDeletion: Bool // Flag to determine if delete option should be shown

    // Filter out deleted hotels for this view only if shouldFilterDeleted is true
    var filteredHotels: [Hotel] {
        allowDeletion ? hotels.filter { !$0.isDeleted } : hotels
    }

    var body: some View {
        List {
            ForEach(filteredHotels) { hotel in
                HotelRowView(hotel: hotel, allowDeletion: allowDeletion, favoritesModel: favoritesModel, selectedHotel: $selectedHotel)
            }
            .if(allowDeletion) {
                $0.onDelete(perform: deleteHotel)
            }
        }
        .sheet(item: $selectedHotel) { listing in
            ListingDetailView(listing: listing)
        }
    }

    private func deleteHotel(at offsets: IndexSet) {
        for index in offsets {
            let hotel = filteredHotels[index]
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
        .contextMenu {
            if allowDeletion {
                Button(action: {
                    deleteHotel(hotel)
                }) {
                    Label("Delete", systemImage: "trash")
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
        // Implement hotel deletion logic using favoritesModel
        favoritesModel.deleteHotel(hotel)
    }
}


struct FiltersListView: View {
    var filters: [Filter]
    @ObservedObject var favoritesModel: FavoritesModel

    var body: some View {
        List(filters) { filter in
            NavigationLink(destination: HotelsListView(hotels: filter.hotels, favoritesModel: favoritesModel, allowDeletion: false)) { // Set allowDeletion to false
                VStack(alignment: .leading) {
                    HStack {
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
                        Spacer()
                        if filter.hotels.contains(where: { $0.isNew }) {
                            Circle()
                                .fill(Color.blue)
                                .frame(width: 10, height: 10)
                        }
                    }
                }
                .foregroundColor(.black) // Ensuring black text color
            }
        }
    }

    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}



