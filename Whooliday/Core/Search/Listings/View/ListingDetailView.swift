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
                            
                            // Hotel info
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    
                                       
                                    Text(String(viewModel.selectedHotelDetails?.accomodationType ?? "Unknown"))
                                    Text(String(viewModel.selectedHotelDetails?.numberOfBeds ?? "Unknown"))
                                    .font(.caption)
                                }
                                .frame(width: 250, alignment: .leading)
                                
                                Spacer()
                                let sym = viewModel.selectedHotelDetails?.accomodationID ?? 0
                                Image(systemName: String(getHotelTypeSymbol(for: Int(sym))))
                                    .font(.system(size: 30))
                                    .imageScale(.large)
                                    .padding(.horizontal)


                               
                            }
                            .padding()
                            
                            Divider()
                            
                            
                            
                            // Rooms
                            VStack(alignment: .leading) {
                                Text("Ecco dove dormirai")
                                    .font(.headline)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 16) {
                                        ForEach(1..<5) { bedroom in
                                            VStack {
                                                Image(systemName: "bed.double")
                                                Text("Bedroom \(bedroom)")
                                            }
                                            .frame(width: 132, height: 100)
                                            .overlay {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundStyle(.gray)
                                            }
                                        }
                                    }
                                }
                                .scrollTargetBehavior(.paging)
                            }
                            .padding()
                            
                            Divider()
                            
                            // Listing amenities
                            VStack(alignment: .leading, spacing: 16) {
                                Text("Cosa offre")
                                    .font(.headline)
                                
                                ForEach(0..<5) { feature in
                                    HStack {
                                        Image(systemName: "wifi")
                                            .frame(width: 32)
                                        
                                        Text("Wifi")
                                            .font(.footnote)
                                        
                                        Spacer()
                                    }
                                }
                            }
                            .padding()
                            
                            Divider()
                            // Listing features
                            VStack(alignment: .leading, spacing: 16) {
                                PriceChartView(viewModel: viewModel)
                                               
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
func getHotelTypeSymbol(for hotelTypeId: Int) -> String {
    switch hotelTypeId {
    case 201: return "building.2" // Apartments
    case 202: return "house" // Guest accommodation
    case 203: return "bed.double" // Hostels
    case 204: return "building" // Hotels
    case 205: return "house.lodge" // Motels
    case 206: return "sun.horizon" // Resorts
    case 207: return "house.fill" // Residences
    case 208: return "cup.and.saucer" // Bed and breakfasts
    case 209: return "house.lodge" // Ryokans
    case 210: return "leaf" // Farm stays
    case 212: return "tent" // Holiday parks
    case 213: return "house" // Villas
    case 214: return "figure.hiking" // Campsites
    case 215: return "sailboat" // Boats
    case 216: return "house" // Guest houses
    case 217: return "questionmark.circle" // Uncertain
    case 218: return "mug" // Inns
    case 219: return "building.columns" // Aparthotels
    case 220: return "house" // Holiday homes
    case 221: return "tree" // Lodges
    case 222: return "house.fill" // Homestays
    case 223: return "house" // Country houses
    case 224: return "tent" // Luxury tents
    case 225: return "square.grid.3x3.fill" // Capsule hotels
    case 226: return "heart" // Love hotels
    case 227: return "building.columns.fill" // Riads
    case 228: return "snow" // Chalets
    case 229: return "building.2.fill" // Condos
    case 230: return "house" // Cottages
    case 231: return "dollarsign.circle" // Economy hotels
    case 232: return "house" // Gites
    case 233: return "heart.circle" // Health resorts
    case 234: return "ferry" // Cruises
    case 235: return "graduationcap" // Student accommodation
    default: return "building" // Default symbol
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
                                                          facilities: "3,4")
    return ListingDetailView(
        listing: Listing(
            id: 1,
            latitude: 0.0,
            longitude: 0.0,
            city: "Milano",
            state: "IT",
            name: "Example Hotel",
            strikethrough_price: 199.99,
            review_count: 111,
            review_score: 8.8,
            checkin: "17-09-2024",
            checkout: "20-09-2024",
            nAdults: 4,
            nChildren: 2,
            childrenAge: "[2,3]",
            currency: "EUR",
            images: ["https://cf.bstatic.com/xdata/images/hotel/max1280x900/56347948.jpg"]
        ),
        viewModel: exampleViewModel
    )
}



