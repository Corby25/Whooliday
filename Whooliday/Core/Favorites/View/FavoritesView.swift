import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesModel = FavoritesModel()
    @State private var selectedTab = 0 // 0: Hotels, 1: Filters
    
    private var hasNewHotels: Bool {
        return favoritesModel.hotels.contains(where: { $0.isNew })
    }
    
    private var hasNewFilters: Bool {
        return favoritesModel.filters.contains(where: { $0.hotels.contains(where: { $0.isNew }) })
    }

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
                    // Display hotels list
                    HotelsListView(hotels: favoritesModel.hotels)
                } else {
                    // Display filters list
                    FiltersListView(filters: favoritesModel.filters)
                }
            }
            .navigationTitle("Favorites")
        }
    }
}


struct HotelsListView: View {
    var hotels: [Hotel]

    var body: some View {
        List(hotels) { hotel in
            HStack {
                Text(hotel.hotelID)
                if hotel.isNew {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 10, height: 10)
                }
            }
        }
        .navigationTitle("Hotels")
    }
}

struct FiltersListView: View {
    var filters: [Filter]

    var body: some View {
        List(filters) { filter in
            NavigationLink(destination: HotelsListView(hotels: filter.hotels)) {
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
            }
        }
        .navigationTitle("Filters")
    }
    
    private func formattedDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}
