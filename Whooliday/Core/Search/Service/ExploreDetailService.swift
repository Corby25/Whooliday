//
//  ExploreDetailService.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 24/06/24.
//

import Foundation


class HotelDetailsService {
    func fetchHotelDetails(for listing: Listing) async throws -> HotelDetails {
        
            let baseURLString = "http://34.16.172.170:3000/api/fetchFullHotelByIDSummary"
            
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw URLError(.badURL)
            }
            
            urlComponents.queryItems = [
                listing.nChildren != 0 ? URLQueryItem(name: "children_number", value: String(listing.nChildren)) : nil,
                URLQueryItem(name: "locale", value: "it"),
                listing.nChildren != 0 ? URLQueryItem(name: "children_ages", value: String(listing.childrenAge.map { String($0) }.joined(separator: ","))) : nil,
                URLQueryItem(name: "filter_by_currency", value: String(listing.currency)),
                URLQueryItem(name: "checkin_date", value: String(listing.checkin)),
                URLQueryItem(name: "hotel_id", value: String(listing.id)),
                URLQueryItem(name: "adults_number", value: String(listing.nAdults)),
                URLQueryItem(name: "checkout_date", value: listing.checkout),
                URLQueryItem(name: "units", value: "metric")
            ]
            .compactMap { $0 }
        /*
         http://34.16.172.170:3000/api/fetchFullHotelByID?children_number=2&locale=it&children_ages=5%2C0&filter_by_currency=EUR&checkin_date=2024-09-17&hotel_id=9481490&adults_number=4&checkout_date=2024-09-20&units=metric
         */
            
            guard let url = urlComponents.url else {
                throw URLError(.badURL)
            }
            
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                
                let hotelDetails = try JSONDecoder().decode(HotelDetails.self, from: data)
                return hotelDetails
            } catch {
                throw error
            }
        }
    
       // Funzione helper per formattare le date
       private func formatDate(_ date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateFormat = "yyyy-MM-dd"
           return formatter.string(from: date)
       }
    
    func fetchListings() async throws -> [Listing] {
        let urlString = "http://34.16.172.170:3000/api/search"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let listings = try JSONDecoder().decode([Listing].self, from: data)
            return listings
        } catch {
            throw error // Propagate any URLSession or JSON decoding errors
        }
    }
    
    
    
    
}

struct HotelDetails: Codable {
    let reviewScoreWord: String
    let city: String
    let state: String
    let accomodationType: String
    let numberOfBeds: String
    let checkinFrom: String
    let checkinTo: String
    let checkoutFrom: String
    let checkoutTo: String
    let info: String
    let accomodationID: Int
    let facilities: String
}

