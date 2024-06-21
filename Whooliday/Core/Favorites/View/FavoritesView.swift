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
            Text(hotel.hotelID)
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
                    Text("Max Price: \(filter.maxPrice)")
                    Text("Num Guests: \(filter.numGuests)")
                    Text("X: \(filter.x)")
                    Text("Y: \(filter.y)")
                }
            }
        }
        .navigationTitle("Filters")
    }
}

struct FilterDetailView: View {
    var filter: Filter

    var body: some View {
        VStack(alignment: .leading) {
            Text("Max Price: \(filter.maxPrice)")
            Text("Num Guests: \(filter.numGuests)")
            Text("X: \(filter.x)")
            Text("Y: \(filter.y)")
            
            if !filter.hotels.isEmpty {
                NavigationLink(destination: HotelsListView(hotels: filter.hotels)) {
                    Text("View Hotels")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            } else {
                Text("No hotels available")
            }
        }
        .padding()
        .navigationTitle("Filter Detail")
    }
}
