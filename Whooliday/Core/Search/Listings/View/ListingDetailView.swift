//
//  ListingDetailView.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 20/06/24.
//

import SwiftUI
import MapKit



struct ListingDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State private var scrollOffset: CGFloat = 0
    let listing: Listing
    @StateObject var viewModel: ExploreViewModel

    var body: some View {
       
        GeometryReader { geometry in
            ZStack(alignment: .top) {
                ListingImageCarouseView(listing: listing)
                    .frame(height: 300)
                    .offset(y: -scrollOffset / 4)
                    .blur(radius: scrollOffset / 100)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 0) {
                        Color.clear.frame(height: 320)
                        
                        VStack {
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
                                        Text("\(listing.review_count) Recensioni")
                                            .underline()
                                            .fontWeight(.semibold)
                                    }
                                    .font(.caption)
                                    .foregroundColor(.black)
                                    if let city = viewModel.selectedHotelDetails?.city,
                                               let state = viewModel.selectedHotelDetails?.state {
                                                Text("\(city), \(state)")
                                                    .padding(.top, 2)
                                            } else {
                                                ShimmeringViewDetail()
                                            }
                                    
                                }
                                .font(.caption)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Divider()
                            
                            // Rooms
                            VStack(alignment: .leading) {
                                Text("Ospiti")
                                    .font(.headline)
                                Spacer()
                                
                              
                                HStack(alignment: .center) {
                                    
                                        VStack {
                                            HStack(spacing: 8) {
                                                ForEach(0..<(listing.nAdults), id: \.self) { _ in
                                                    Image(systemName: "figure")
                                                        .font(.system(size: 30))
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            Text("Adulti: \(listing.nAdults)")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                       
                                        Spacer()
                                        
                                        
                                        VStack {
                                            HStack(spacing: 8) {
                                                ForEach(0..<(listing.nChildren), id: \.self) { _ in
                                                    Image(systemName: "figure.child")
                                                        .font(.system(size: 30))
                                                        .fontWeight(.bold)
                                                }
                                            }
                                            Text("Bambini: \(listing.nChildren)")
                                                .font(.headline)
                                                .fontWeight(.semibold)
                                        }
                                        
                                        
                                       
                                    }
                                .padding()
                                
                               
                              
                            }
                            .padding()
                            
                            Divider()
                            
                            
            
                            
                            // Listing amenities
                            // Listing amenities
                            // Listing amenities
                            // Listing amenities
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Cosa offre")
                                    .font(.headline)
                                
                                if let facilities = viewModel.selectedHotelDetails?.facilities {
                                    ForEach(facilities.components(separatedBy: ","), id: \.self) { facilityId in
                                        if let id = Int(facilityId.trimmingCharacters(in: .whitespaces)) {
                                            let (symbol, name) = getHotelFacilitySymbolAndName(for: id)
                                            if name != "none"{
                                                HStack {
                                                    Image(systemName: symbol)
                                                        .frame(width: 32)
                                                    
                                                    Text(name)
                                                        .font(.footnote)
                                                    
                                                    Spacer()
                                                }
                                            }
                                        }
                                    }
                                } else {
                                    Text("Nessuna facility disponibile")
                                        .font(.footnote)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding()
                            
                            Divider()
                            // Listing features
                            VStack(alignment: .leading, spacing: 16) {
                                PriceChartView(viewModel: viewModel)
                                    .onAppear {
                                        viewModel.fetchPriceCalendar(for: listing)
                                    }
                                               
                                /*
                                ForEach(0..<2) { feature in
                                    HStack(spacing: 12) {
                                        Image(systemName: "medal")
                                        
                                        VStack(alignment: .leading) {
                                            Text("Superhost")
                                                .font(.footnote)
                                                .fontWeight(.semibold)
                                            
                                            Text("Superhost è meglio")
                                                .font(.caption)
                                                .foregroundStyle(.gray)
                                        }
                                        
                                        Spacer()
                                    }
                                }
                                 */
                            }
                            .padding()
                            .padding(.top, 10)
                            .padding(.bottom, -10)
                            
                            Divider()
                            
                            // Map view
                            VStack(alignment: .leading, spacing: 24) {
                                Text("Dove alloggerai")
                                    .font(.headline)
                                
                                Map()
                                    .frame(height: 200)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            .padding()
                        }
                        .background(Color.white)
                        .cornerRadius(20)
                        
                    }
                    .background(GeometryReader { geo in
                        Color.clear
                            .preference(key: ScrollOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                    })
                }
                .coordinateSpace(name: "scroll")

                VStack {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 23, weight: .semibold))
                                .padding(.horizontal, 10)
                                .controlGroupStyle(.palette)
                                .foregroundStyle(.black)
                                
                        }
                        
                        Spacer()
                        
                        HStack(spacing: 30) {
                            Button {
                                // Azione del pulsante condividi
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.system(size: 20, weight: .semibold))
                                    .controlGroupStyle(.palette)
                                    .foregroundStyle(.black, .gray)
                            }
                            
                            Button {
                                // Azione del pulsante cuore
                            } label: {
                                Image(systemName: "heart")
                                    .font(.system(size: 20, weight: .semibold))
                                    .controlGroupStyle(.palette)
                                    .foregroundStyle(.black, .gray)
                            }
                        }
                        .padding(.horizontal, 10)
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    .background(scrollOffset > 300 ? Color.white : Color.clear)
                    .animation(.easeInOut, value: scrollOffset > 300)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            
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
                        
                        Text("Totale")
                        Text("Jun 15 - 20")
                            .font(.footnote)
                            .fontWeight(.semibold)
                            .underline()
                    }
                    
                    Spacer()
                    
                    Button {
                        // Azione del pulsante Reserve
                    } label: {
                        Text("Reserve")
                            .foregroundStyle(.white)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .frame(width: 140, height: 40)
                            .background(.pink)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(.horizontal, 32)
            }
            .background(.white)
        }
        
        .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
            scrollOffset = max(0, -value)
        }
        .ignoresSafeArea(edges: .top)
        .task {
                   await viewModel.fetchHotelDetails(for: listing)
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
            latitude: 0.0,
            longitude: 0.0,
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
            images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/56347948.jpg"]
        ),
        viewModel: exampleViewModel
    )
}



