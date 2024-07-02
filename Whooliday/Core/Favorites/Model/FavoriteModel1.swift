//
//  FavoriteModel1.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 30/06/24.
//

import Foundation
import Combine
import FirebaseAuth
import Firebase

class FavoriteModel1: ObservableObject {
    @Published var favoriteListings: [Listing] = []
    @Published var isLoading = false

    private let db = Firestore.firestore()

    func fetchFavoriteListings() {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        isLoading = true
        
        let listingsRef = db.collection("users").document(userId).collection("favorites").document("hotels").collection("all")
        
        
        listingsRef.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            self.isLoading = false
            
            if let error = error {
                print("Error fetching favorites: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No documents found")
                return
            }
            
            for document in documents {
                do {
                    let hotelParams = try document.data(as: HotelQueryParams.self)
                    self.fetchHotelDetails(with: hotelParams)
                } catch {
                    print("Unable to decode document into HotelQueryParams")
                    print("Error: \(error)")
                    print("Document data:")
                    for (key, value) in document.data() {
                        print("\(key): \(value) (type: \(type(of: value)))")
                    }
                }
            }
        }
    }
        

    private func fetchHotelDetails(with params: HotelQueryParams) {
        var components = URLComponents(string: "http://localhost:3000/api/fetchHotelByID")
        components?.queryItems = [
            params.nChildren != 0 ?         URLQueryItem(name: "children_number", value: params.nChildren.map { String($0) }): nil,
            URLQueryItem(name: "locale", value: "it"),
            params.nChildren != 0 ? URLQueryItem(name: "children_ages", value: params.childrenAge) : nil,
            URLQueryItem(name: "filter_by_currency", value: params.currency),
            URLQueryItem(name: "checkin_date", value: params.checkin),
            URLQueryItem(name: "hotel_id", value: String(params.id)),
            URLQueryItem(name: "adults_number", value: String(params.nAdults)),
            URLQueryItem(name: "checkout_date", value: params.checkout),
            URLQueryItem(name: "units", value: "metric")
        ].compactMap { $0 }

        guard let url = components?.url else {
            print("Invalid URL")
            return
        }
        print(url)

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let error = error {
                print("Error fetching hotel details: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }
            
            
            do {
                let listing = try JSONDecoder().decode(Listing.self, from: data)
                DispatchQueue.main.async {
                    self?.favoriteListings.append(listing)
                    print(listing)
                }
            } catch {
                print("Error decoding hotel details: \(error.localizedDescription)")
            }
        }.resume()
    }
}


struct HotelQueryParams: Codable {
    let nChildren: Int?
    let childrenAge: String?
    let checkin: String
    let checkout: String
    let city: String
    let currency: String
    let id: Int
    let nAdults: Int
 
   
 
}
