import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesModel = FavoritesModel()
    @State private var selectedTab = 0 // 0: Hotels, 1: Filters

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Cogli le occasioni")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Seleziona un hotel o un filtro")
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
                headerView // Custom header view

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
            .navigationBarHidden(true) // Hide the default navigation title
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
        .sheet(item: $selectedHotel) { listing in
            ListingDetailView(listing: listing, viewModel: ExploreViewModel(service: ExploreService()))
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
                            .foregroundColor(.black)
                            .lineLimit(1) // Ensure the hotel name stays on a single line

                        Text("\(hotel.city ?? "City")")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("From: \(hotel.checkIn)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        Text("To: \(hotel.checkOut)")
                            .font(.subheadline)
                            .foregroundColor(.gray)

                        if let childrenNumber = hotel.childrenNumber {
                            Text("Number of guests: \(hotel.adultsNumber + childrenNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        } else {
                            Text("Number of guests: \(hotel.adultsNumber)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        if hotel.newPrice == 0 {
                            Text("Esaurito")
                                .font(.subheadline)
                                .foregroundColor(.red)
                        } else if hotel.newPrice != hotel.oldPrice {
                            Text("€\(hotel.oldPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .strikethrough(true, color: .red)
                            Text("€\(hotel.newPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.black)
                        } else {
                            Text("€\(hotel.newPrice, specifier: "%.2f")")
                                .font(.subheadline)
                                .foregroundColor(.black)
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
            .background(Color.white)
            .cornerRadius(10)
        }
    }

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
                            if let id = filter.id {
                                favoritesModel.markFilterAsNotNew(withId: id)
                            }
                        }
                    )
                ) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .fill(colors[index % colors.count])
                                .frame(width: 30, height: 30)
                            
                            Text("\(index + 1)")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                        .padding(.leading, -5)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Text("Da:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text(filter.checkIn)
                                    .font(.subheadline)
                                Text("A:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                    .padding(.leading,1)
                                Text(filter.checkOut)
                                    .font(.subheadline)
                            }
                            HStack {
                                Text("Prezzo massimo:")
                                    .font(.caption)
                                    .foregroundColor(.gray)

                                if filter.maxPrice == 0 {
                                    Text("Non selezionato")
                                        .font(.subheadline)
                                } else {
                                    Text("\(filter.maxPrice, specifier: "%.2f") \(favoritesModel.userCurrency)")
                                        .font(.subheadline)
                                }
                            }
                            HStack {
                                Text("Numero di ospiti:")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                                Text("\(filter.adultsNumber + filter.childrenNumber)")
                                    .font(.subheadline)
                            }
                            HStack {
                                Text("Dove:")
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
                               Label("Visualizza", systemImage: "eye")
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
                           Label("Rimuovi", systemImage: "trash")
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
