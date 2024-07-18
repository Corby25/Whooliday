//
//  ExploreViewModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 21/06/24.
//

import Foundation


// model for the search function, it uses customAPI to retrive data based on user's preferences (destination, date interval and guests)
class ExploreViewModel: ObservableObject {
    @Published var listings = [Listing]()
    private let service: ExploreServiceProtocol
    @Published var isLoading = false
    @Published var selectedHotelDetails: HotelDetails?
    private let hotelDetailsService: HotelDetailsService
    @Published var isLoadingFacilities = false
    init(service: ExploreServiceProtocol,  hotelDetailsService: HotelDetailsService = HotelDetailsService()) {
        self.service = service
        self.hotelDetailsService = hotelDetailsService
    }
    
    
    // fetch listing throught a customAPI
    func fetchListings(with parameters: SearchParameters) {
        isLoading = true
        Task {
            do {
                try await service.getLatLong(with: String(parameters.placeID))
                
                let fetchedListings = try await service.fetchListings(with: parameters)
                DispatchQueue.main.async {
                    self.listings = fetchedListings
                    self.isLoading = false
                }
            } catch {
                print("Error fetching listings list of hotels: \(error)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }
    }
    
    // find hotel type (hotel, hostel, house, villa and so on)
    func fetchHotelType(listing: Listing, accomodationType: Int) async throws -> Bool {
        
        let baseURLString = "http://34.16.172.170:3000/api/fetchFullHotelByIDSummary"
        
        guard var urlComponents = URLComponents(string: baseURLString) else {
            throw URLError(.badURL)
        }
        
        urlComponents.queryItems = [
            listing.nChildren != 0 ? URLQueryItem(name: "children_number", value: String(listing.nChildren ?? 0)) : nil,
            URLQueryItem(name: "locale", value: "it"),
            listing.nChildren != 0 ? listing.childrenAge.flatMap { ages in
                let agesString = ages.map { String($0) }.joined(separator: ",")
                return URLQueryItem(name: "children_ages", value: agesString)
            } : nil ,
            URLQueryItem(name: "filter_by_currency", value: String(listing.currency)),
            URLQueryItem(name: "checkin_date", value: String(listing.checkin)),
            URLQueryItem(name: "hotel_id", value: String(listing.id)),
            URLQueryItem(name: "adults_number", value: String(listing.nAdults)),
            URLQueryItem(name: "checkout_date", value: listing.checkout),
            URLQueryItem(name: "units", value: "metric")
        ].compactMap { $0 }
        /*
         http://34.16.172.170:3000/api/fetchFullHotelByID?children_number=2&locale=it&children_ages=5%2C0&filter_by_currency=EUR&checkin_date=2024-09-17&hotel_id=9481490&adults_number=4&checkout_date=2024-09-20&units=metric
         */
        
        guard let url = urlComponents.url else {
            throw URLError(.badURL)
        }
        
        print(url)
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let hotelDetails = try JSONDecoder().decode(HotelDetails.self, from: data)
            if(Int(hotelDetails.accomodationID) == accomodationType){
                return true
            }
            else {
                return false
            }
        } catch {
            throw error
        }
    }
    
    @MainActor
    func fetchHotelDetails(for listing: Listing) async{
        isLoadingFacilities = true
        do {
            self.selectedHotelDetails = try await hotelDetailsService.fetchHotelDetails(for: listing)
        } catch {
            print("Error fetching hotel details: \(error)")
        }
        self.isLoadingFacilities = false
    }
    
    @Published var dailyPrices: [(String, Double)] = []
    @Published var weeklyPrices: [(String, Double)] = []
    @Published var showDailyPrices = true
    
    @Published var priceCalendar: [String: PriceData] = [:]
    @Published var weeklyAverages: [(String, Double)] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d yyyy"
        return formatter
    }()
    
    
    // used to fetch future price (daily and weekly) through the custom accomodation API
    func fetchPriceCalendar(for listing: Listing) {
        let baseURLString = "http://34.16.172.170:3000/api/fetchCalendarPrices"
        
        guard var urlComponents = URLComponents(string: baseURLString) else {
            print("Invalid URL")
            return
        }
        
        urlComponents.queryItems = [
            listing.nChildren != 0 ? URLQueryItem(name: "children_number", value: String(listing.nChildren!)) : nil,
            URLQueryItem(name: "checkout_date", value: listing.checkout),
            URLQueryItem(name: "locale", value: "it"),
            listing.nChildren != 0 ? URLQueryItem(name: "children_ages", value: listing.childrenAge) : nil,
            URLQueryItem(name: "hotel_id", value: String(listing.id)),
            URLQueryItem(name: "adults_number", value: String(listing.nAdults)),
            URLQueryItem(name: "currency_code", value: listing.currency),
            URLQueryItem(name: "checkin_date", value: listing.checkin)
        ].compactMap { $0 }
        
        guard let url = urlComponents.url else {
            print("Could not create URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching price calendar: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let priceCalendar = try decoder.decode([String: PriceData].self, from: data)
                DispatchQueue.main.async {
                    self?.priceCalendar = priceCalendar
                    self?.updatePrices()
                }
            } catch {
                print("Error decoding price calendar: \(error.localizedDescription)")
            }
        }.resume()
    }
    
    func updatePrices() {
        dailyPrices = priceCalendar.map { (formattedDate($0.key), $0.value.daily) }
            .sorted { dateFormatter.date(from: $0.0)! < dateFormatter.date(from: $1.0)! }
        calculateWeeklyAverages()
    }
    
    // calculate weekly averages
    func calculateWeeklyAverages() {
        let sortedDailyPrices = dailyPrices.compactMap { dateString, price -> (Date, Double)? in
            if let date = dateFormatter.date(from: dateString) {
                return (date, price)
            }
            print("Warning: Unable to parse date: \(dateString)")
            return nil
        }.sorted { $0.0 < $1.0 }
        
        var weeklyAverages: [(String, Double)] = []
        var currentWeekPrices: [Double] = []
        var weekStartDate = ""
        
        for (index, (date, price)) in sortedDailyPrices.enumerated() {
            if index % 7 == 0 {
                if !currentWeekPrices.isEmpty {
                    let average = currentWeekPrices.reduce(0, +) / Double(currentWeekPrices.count)
                    weeklyAverages.append((weekStartDate, average))
                }
                currentWeekPrices = []
                weekStartDate = dateFormatter.string(from: date)
            }
            currentWeekPrices.append(price)
        }
        
        if !currentWeekPrices.isEmpty {
            let average = currentWeekPrices.reduce(0, +) / Double(currentWeekPrices.count)
            weeklyAverages.append((weekStartDate, average))
        }
        
        self.weeklyAverages = weeklyAverages
    }
    
    private func formattedDate(_ dateString: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = inputFormatter.date(from: dateString) {
            return dateFormatter.string(from: date)
        }
        return dateString
    }
    
    
}

// protocols used for testing
protocol ExploreServiceProtocol {
    func getLatLong(with pid: String) async throws
    func fetchListings(with parameters: SearchParameters) async throws -> [Listing]
}

protocol ExploreDetailServiceProtocol{
    func fetchHotelDetails(for listing: Listing) async throws -> [Listing]
}

struct PriceData: Codable {
    let daily: Double
}

// date formatted to be compatible with the SwiftChart Library

private func formattedDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d yyyy"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}


