//
//  ListingDetailView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import MapKit
import SafariServices


// used to the detailed view of an accomodation, it uses local info and custom API to retreive additional information about the accomodation
struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scrollOffset: CGFloat = 0
    let listing: Listing
    @StateObject var viewModel: ExploreViewModel
    @State var showAllFacilities = false
    @Namespace private var animation
    @State  var region: MKCoordinateRegion
    @State  var isFavorite: Bool = false
    @ObservedObject var firebaseManager = FirebaseManager.shared
    @Environment(\.colorScheme) var colorScheme
    init(listing: Listing, viewModel: ExploreViewModel) {
        self.listing = listing
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._region = State(initialValue: MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: listing.latitude, longitude: listing.longitude),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ))
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                VStack {
                    ScrollView {
                        VStack(spacing: 0) {
                            ListingImageCarouseView(listing: listing)
                                .frame(height: 300)
                                .offset(y: -scrollOffset / 4)
                                .blur(radius: scrollOffset / 100)
                                .ignoresSafeArea()
                            
                            // Contenuto principale
                            VStack(alignment: .leading, spacing: 8) {
                                Text(listing.name)
                                    .font(.title)
                                    .fontWeight(.semibold)
                                
                                VStack(alignment: .leading) {
                                    HStack(spacing: 2) {
                                        Image(systemName: "star.fill")
                                        Text(String(format: "%.1f", listing.review_score))
                                        Text(" - ")
                                        Text(String(format: NSLocalizedString("%d reviews", comment: "Number of reviews"),
                                                    listing.review_count))
                                        .underline()
                                        .fontWeight(.semibold)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.primary)
                                    
                                    if let city = viewModel.selectedHotelDetails?.city,
                                       let state = viewModel.selectedHotelDetails?.state {
                                        Text("\(city), \(state)")
                                            .padding(.top, 2)
                                    } else {
                                        ZStack(alignment: .leading) {
                                            ShimmeringViewDetail()
                                        }
                                        .frame(width: 50)
                                        .clipShape(RoundedRectangle(cornerRadius: 15))
                                    }
                                }
                                .font(.caption)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemBackground))
                            
                            Divider()
                            
                            // Rooms
                            VStack(alignment: .leading) {
                                Text(NSLocalizedString("Guests", comment: ""))
                                    .font(.headline)
                                Spacer()
                                
                                HStack(alignment: .top) {
                                    VStack {
                                        HStack(spacing: 8) {
                                            ForEach(0..<(listing.nAdults), id: \.self) { _ in
                                                Image(systemName: "figure")
                                                    .font(.system(size: 30))
                                                    .fontWeight(.bold)
                                            }
                                        }
                                        Text(String(format: NSLocalizedString("Adults: %d", comment: "Number of adults"),
                                                    listing.nAdults))
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                    }
                                    
                                    Spacer()
                                    
                                    if ((listing.nChildren ?? 0) > 0) {
                                        VStack {
                                            HStack(spacing: 8) {
                                                ForEach(0..<(listing.nChildren ?? 0), id: \.self) { _ in
                                                    Image(systemName: "figure.child")
                                                        .font(.system(size: 30))
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            Text(String(format: NSLocalizedString("Children: %d", comment: "Number of children"),
                                                        listing.nChildren ?? 0))
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                        }
                                    }
                                }
                                .padding()
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            
                            Divider()
                            
                            // Listing amenities
                            VStack(alignment: .leading, spacing: 16) {
                                Text(NSLocalizedString("What it offers", comment: ""))
                                    .font(.headline)
                                
                                if viewModel.isLoadingFacilities {
                                    HStack(alignment: .center, spacing: 10) {
                                        ForEach(0..<3) { index in
                                            Circle()
                                                .fill(Color.gray)
                                                .frame(width: 8, height: 8)
                                                .offset(y: viewModel.isLoadingFacilities ? -5 : 0)
                                                .animation(
                                                    Animation.easeInOut(duration: 0.5)
                                                        .repeatForever(autoreverses: true)
                                                        .delay(Double(index) * 0.2),
                                                    value: viewModel.isLoadingFacilities
                                                )
                                        }
                                    }
                                    .padding()
                                } else if let facilities = viewModel.selectedHotelDetails?.facilities {
                                    let facilitiesArray = facilities.components(separatedBy: ",")
                                    ForEach(facilitiesArray.indices, id: \.self) { index in
                                        if index < 5 || showAllFacilities {
                                            if let id = Int(facilitiesArray[index].trimmingCharacters(in: .whitespaces)) {
                                                let (symbol, name) = getHotelFacilitySymbolAndName(for: id)
                                                if name != "none" {
                                                    HStack {
                                                        Image(systemName: symbol)
                                                            .frame(width: 32)
                                                        Text(name)
                                                            .font(.footnote)
                                                        Spacer()
                                                    }
                                                    .matchedGeometryEffect(id: "facility\(id)", in: animation)
                                                    .transition(.asymmetric(insertion: .scale.combined(with: .opacity),
                                                                            removal: .scale.combined(with: .opacity)))
                                                }
                                            }
                                        }
                                    }
                                    
                                    if facilitiesArray.count > 5 {
                                        Button(action: {
                                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                                                showAllFacilities.toggle()
                                            }
                                        }) {
                                            HStack {
                                                Text(showAllFacilities ? NSLocalizedString("Show less", comment: "") : NSLocalizedString("Show more", comment: ""))
                                                    .font(.footnote)
                                                    .foregroundColor(.orange)
                                                    .fontWeight(.bold)
                                                Image(systemName: showAllFacilities ? "chevron.up" : "chevron.down")
                                                    .foregroundColor(.orange)
                                                    .fontWeight(.bold)
                                                    .rotationEffect(.degrees(showAllFacilities ? 180 : 0))
                                                    .animation(.easeInOut, value: showAllFacilities)
                                            }
                                        }
                                        .padding(.top, 8)
                                    }
                                } else {
                                    Text(NSLocalizedString("No any facility available", comment: ""))
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .animation(.spring(response: 0.5, dampingFraction: 0.7), value: showAllFacilities)
                            
                            Divider()
                            
                            // Listing features
                            VStack(alignment: .leading, spacing: 16) {
                                PriceChartView(viewModel: viewModel)
                                    .onAppear {
                                        viewModel.fetchPriceCalendar(for: listing)
                                    }
                            }
                            .padding()
                            .padding(.top, 10)
                            .padding(.bottom, -10)
                            .background(Color(.systemBackground))
                            
                            Divider()
                            
                            // Map view
                            VStack(alignment: .leading, spacing: 24) {
                                Text(NSLocalizedString("Where you will stay", comment: ""))
                                    .font(.headline)
                                
                                Map(coordinateRegion: $region, annotationItems: [listing]) { item in
                                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: item.latitude, longitude: item.longitude))
                                }
                                .frame(height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding()
                            .background(Color(.systemBackground))
                        }
                        .cornerRadius(20)
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                    })
                }
                .coordinateSpace(name: "scroll")
                .padding(.bottom, 100)
                
                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 23, weight: .semibold))
                                .padding(.horizontal, 10)
                                .controlGroupStyle(.palette)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button {
                                shareGoogleSearchURL()
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20, weight: .semibold))
                                    .controlGroupStyle(.palette)
                                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                            }
                            
                            HeartButton(isFavorite: isFavorite, listing: listing) {
                                toggleFavorite()
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .background(scrollOffset > 300 ? Color(.systemBackground) : Color.clear)
                    .animation(.easeInOut, value: scrollOffset > 300)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
        .onAppear {
            checkFavoriteStatus()
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(edges: .top)
        .overlay(alignment: .bottom) {
            VStack {
                Divider()
                    .padding(.bottom)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(Int(listing.price))€")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        Text(NSLocalizedString("Total", comment: ""))
                        Text("\(listing.checkin) - \(listing.checkout)")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    
                    Spacer()
                    
                    Button {
                        openGoogleSearch()
                    } label: {
                        Text(NSLocalizedString("Book it now", comment: ""))
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 160, height: 40)
                            .background(Color.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 32)
                .background(Color(.systemBackground))
            }
            .background(Color(.systemBackground))
        }
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = max(0, -value)
        }
        .ignoresSafeArea(edges: .top)
        .task {
            await viewModel.fetchHotelDetails(for: listing)
        }
    }
    
    func checkFavoriteStatus() {
        firebaseManager.isListingFavorite(listingId: listing.id) { result in
            DispatchQueue.main.async {
                self.isFavorite = result
            }
        }
    }
    
    func toggleFavorite() {
        if isFavorite {
            firebaseManager.removeFavorite(listingId: listing.id)
        } else {
            firebaseManager.addFavorite(listing: listing)
        }
        isFavorite.toggle()
    }
    
    func openGoogleSearch() {
        guard let url = generateGoogleSearchURL() else { return }
        
        let safariViewController = SFSafariViewController(url: url)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            rootViewController.present(safariViewController, animated: true)
        }
    }
    
    func generateGoogleSearchURL() -> URL? {
        let searchQuery = "\(listing.name) \(listing.city)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://www.google.com/search?q=\(searchQuery)"
        return URL(string: urlString)
    }
    
    func shareGoogleSearchURL() {
        guard let url = generateGoogleSearchURL() else { return }
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first,
           let rootViewController = window.rootViewController {
            activityViewController.popoverPresentationController?.sourceView = rootViewController.view
            rootViewController.present(activityViewController, animated: true, completion: nil)
        }
    }
}

struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}





#Preview {
    let exampleService = ExploreService()
    let exampleViewModel = ExploreViewModel(service: exampleService)
    exampleViewModel.selectedHotelDetails = HotelDetails( reviewScoreWord: "7.7",
                                                          city: "Rovaiolo",
                                                          state: "IT",
                                                          accomodationType: "Intera casa vacanze - 140 m²",
                                                          numberOfBeds: "3 letti • 2 camere da letto • 1 zona giorno • 1 bagno",
                                                          checkinFrom: "15:00",
                                                          checkinTo: "22:00",
                                                          checkoutFrom: "9:00",
                                                          checkoutTo: "11:00",
                                                          info: "Prezzo per 3 notti, 4 adulti e 2 bambini ",
                                                          accomodationID: 220,
                                                          facilities: "2,96,108,14,4,28,46,163,160,107,47,16")
    return ListingDetailView(
        listing: Listing(
            id: 9481490,
            latitude: 45.0,
            longitude: 43.0,
            city: "Milano",
            state: "IT",
            name: "Example Hotel",
            strikethrough_price: 199.99,
            review_count: 111,
            review_score: 8.8,
            checkin: "2024-09-15",
            checkout: "2024-09-16",
            nAdults: 4,
            nChildren: 2,
            childrenAge: "2,3",
            currency: "EUR",
            images: ["https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg", "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg"
                     ,"https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg",
                     "https://c4.wallpaperflare.com/wallpaper/377/82/449/5bf55b183fa85-wallpaper-preview.jpg"]
        ),
        viewModel: exampleViewModel
    )
}



