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
        
        var isUserLoggedIn: Bool {
            return Auth.auth().currentUser != nil
        }
    
    func addFavorite(listing: Listing) {
        guard let userId = Auth.auth().currentUser?.uid else {
            
            return
        }
        
        let favoriteData: [String: Any] = [
            "hotelID": listing.id,
            "checkIn": listing.checkin,
            "checkOut": listing.checkout,
            "adultsNumber": listing.nAdults,
            "childrenNumber": listing.nChildren ?? 0,
            "childrenAge": listing.childrenAge ?? "",
            "isDeleted": Bool(false),
            "isNew": Bool(false),
            "newPrice": Int(listing.price) ?? 0,
            "oldPrice": Int(listing.price) ?? 0
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
}
