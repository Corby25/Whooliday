//
//  ExploreService.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation
import CoreLocation



class ExploreService: ExploreServiceProtocol{
    
    private var latitude: Double?
    private var longitude: Double?
    
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
    
    
    func fetchListings(with parameters: SearchParameters) async throws -> [Listing] {
        
        
            // Assicuriamoci di avere latitudine e longitudine
            guard let lat = self.latitude, let lng = self.longitude else {
                throw NSError(domain: "ExploreService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Latitude and longitude not set"])
            }
            
            let baseURLString = "http://localhost:3000/api/search"
            
            guard var urlComponents = URLComponents(string: baseURLString) else {
                throw URLError(.badURL)
            }
            
            urlComponents.queryItems = [
                URLQueryItem(name: "checkin_date", value: formatDate(parameters.startDate)),
                URLQueryItem(name: "room_number", value: "2"),
                URLQueryItem(name: "checkout_date", value: formatDate(parameters.endDate)),
                URLQueryItem(name: "latitude", value: String(lat)),
                URLQueryItem(name: "adults_number", value: String(parameters.guests)),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "filter_by_currency", value: "EUR"),
                URLQueryItem(name: "order_by", value: "distance"),
                URLQueryItem(name: "locale", value: "it"),
                URLQueryItem(name: "longitude", value: String(lng))
            ]
            
            guard let url = urlComponents.url else {
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
        let urlString = "http://localhost:3000/api/search"
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
