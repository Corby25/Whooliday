//
//  FirebaseManager.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 30/06/24.
//

import FirebaseFirestore
import Foundation
import FirebaseAuth
import Combine

class FirebaseManager: ObservableObject {
    
    static let shared = FirebaseManager()
    private let db = Firestore.firestore()
    
    @Published var favorites: Set<Int> = []
    
    var isUserLoggedIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func addFavorite(listing: Listing) {
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let favoriteData: [String: Any] = [
            "hotelID": String(listing.id),
            "checkIn": listing.checkin,
            "checkOut": listing.checkout,
            "adultsNumber": listing.nAdults,
            "childrenNumber": listing.nChildren ?? 0,
            "childrenAge": listing.childrenAge ?? "",
            "isDeleted": Bool(false),
            "isNew": Bool(false),
            "newPrice": Int(listing.strikethrough_price),
            "oldPrice": Int(listing.strikethrough_price)
        ]
        
        db.collection("users").document(userId).collection("favorites").document("hotels").collection("all").document(String(listing.id)).setData(favoriteData) { error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
            } else {
                print("Favorite added successfully")
            }
        }
    }
    
    func removeFavorite(listingId: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        db.collection("users").document(userId).collection("favorites").document("hotels").collection("all").document(String(listingId)).delete() { error in
            if let error = error {
                print("Error removing favorite: \(error.localizedDescription)")
            } else {
                print("Favorite removed successfully")
            }
        }
    }
    
    func getFavoriteListingIds() -> AnyPublisher<[Int], Error> {
        guard let userId = Auth.auth().currentUser?.uid else {
            return Fail(error: NSError(domain: "FirebaseManager", code: 0, userInfo: [NSLocalizedDescriptionKey: "User not logged in"]))
                .eraseToAnyPublisher()
        }
        
        return Future { promise in
            self.db.collection("users").document(userId).collection("favorites").document("hotels").collection("all").getDocuments { snapshot, error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    let ids = snapshot?.documents.compactMap { Int($0.documentID) } ?? []
                    promise(.success(ids))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func addFavoriteFilter(listing: Listing, appliedFilters: String, listings: [Listing]) {
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let favoriteData: [String: Any] = [
            "checkIn": listing.checkin,
            "checkOut": listing.checkout,
            "adultsNumber": listing.nAdults,
            "childrenNumber": listing.nChildren ?? 0,
            "childrenAge": listing.childrenAge ?? "",
            "isDeleted": Bool(false),
            "isNew": Bool(false),
            "latitude": listing.latitude,
            "longitude": listing.longitude,
            "filters": appliedFilters,
            "orderBy": "distance",
            "roomNumber": 1,
            "city": listing.city,
            "units": "metric",
            
        ]
        
        db.collection("users").document(userId).collection("favorites").document("filters").collection("all").document(String(listing.id)).setData(favoriteData) { error in
            if let error = error {
                print("Error adding favorite: \(error.localizedDescription)")
            } else {
                print("Favorite added successfully")
            }
        }
        
        for lis in listings {
            let favoriteDataSingle: [String: Any] = [
                "hotelID": String(lis.id),
                "checkIn": lis.checkin,
                "checkOut": lis.checkout,
                "adultsNumber": lis.nAdults,
                "childrenNumber": lis.nChildren ?? 0,
                "childrenAge": lis.childrenAge ?? "",
                "isDeleted": Bool(false),
                "isNew": Bool(false),
                "newPrice": Int(lis.strikethrough_price),
                "oldPrice": Int(lis.strikethrough_price)
            ]
            
            
            db.collection("users").document(userId).collection("favorites").document("filters").collection("all").document(String(listing.id)).collection("hotels").document(String(lis.id)).setData(favoriteDataSingle) { error in
                if let error = error {
                    print("Error adding favorite: \(error.localizedDescription)")
                } else {
                    print("Favorite added successfully")
                }
            }
        }
        
        
        
        
    }

    func isListingFavorite(listingId: Int, completion: @escaping (Bool) -> Void) {
        guard let userId = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        db.collection("users").document(userId).collection("favorites").document("hotels").collection("all").document(String(listingId)).getDocument { (document, error) in
            if let document = document, document.exists {
                completion(true)
            } else {
                completion(false)
            }
        }
    }

}

