//
//  ExploreService.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation
import CoreLocation


// it exposes some services usefull for the research
class ExploreService: ExploreServiceProtocol{
    
    private var latitude: Double?
    private var longitude: Double?
    
    
    // used to retrive destination coordinates for the search phase
    func getLatLong(with pid: String) async throws {
        let apiKey = "AIzaSyBOiUNEOqhpqUt_dyQTmcCKnscHfJE1VQY"
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?place_id=\(pid)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(GoogleMapsResponse.self, from: data)
            
            guard let location = result.results.first?.geometry.location else {
                throw NSError(domain: "GoogleMapsAPI", code: 0, userInfo: [NSLocalizedDescriptionKey: "No location found"])
            }
            
            self.latitude = location.lat
            self.longitude = location.lng
            
            print("Latitude: \(self.latitude ?? 0), Longitude: \(self.longitude ?? 0)")
        } catch {
            throw error
        }
    }
    
    
    // fetch accomodations in a given place by coordinates using the custom Accomodation API
    func fetchListings(with parameters: SearchParameters) async throws -> [Listing] {
        
    
        guard let lat = self.latitude, let lng = self.longitude else {
            throw NSError(domain: "ExploreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Latitude and longitude not set"])
        }
        
        let baseURLString = "http://34.16.172.170:3000/api/search"
        
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw URLError(.badURL)
        }
        
        let childrenAgesString = parameters.childrenAges.map { String($0) }.joined(separator: ",")
        
        
        
        urlComponents.queryItems = [
            URLQueryItem(name: "checkin_date", value: formatDate(parameters.startDate)),
            URLQueryItem(name: "room_number", value: "1"),
            URLQueryItem(name: "checkout_date", value: formatDate(parameters.endDate)),
            URLQueryItem(name: "latitude", value: String(lat)),
            URLQueryItem(name: "adults_number", value: String(parameters.numAdults)),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "filter_by_currency", value: "EUR"),
            
            parameters.numChildren != 0 ? URLQueryItem(name: "children_number", value: String(parameters.numChildren)) : nil,
            
            
            URLQueryItem(name: "order_by", value: "distance"),
            URLQueryItem(name: "locale", value: "it"),
            URLQueryItem(name: "longitude", value: String(lng)),
            parameters.numChildren != 0 ? URLQueryItem(name: "children_ages", value: childrenAgesString) : nil,
            parameters.filters != "" ? URLQueryItem(name: "filters", value: parameters.filters) : nil
        ].compactMap { $0 }
        
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        print(url)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys // Ensure this is set to use the exact keys from the JSON
            let listings = try decoder.decode([Listing].self, from: data)
            return listings
        } catch {
            throw error
        }
    }
    
    
    
    
    
    
    
    // Funzione helper per formattare le date
    private func formatDate(_ date: Date?) -> String {
        guard let date = date else { return "" }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    
    
    
}

// Strutture per decodificare la risposta di Google Maps
struct GoogleMapsResponse: Codable {
    let results: [Result]
}

struct Result: Codable {
    let geometry: Geometry
}

struct Geometry: Codable {
    let location: Location
}

struct Location: Codable {
    let lat: Double
    let lng: Double
}
