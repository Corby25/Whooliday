//
//  HomeViewModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//

import Foundation
import FirebaseFirestore
class HomeViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var selectedContinent: String = "Mondo"
    
    private let db = Firestore.firestore()
    
    private let continentMapping = [
        "Mondo": "world",
        "Europa": "europe",
        "Asia": "asia",
        "America": "americas",
        "Africa": "africa",
        "Antartide": "antartide",
        "Oceania": "oceania"
    ]
    
    init() {
        fetchPlaces()
    }
    
    func fetchPlaces() {
        let continentCode = continentMapping[selectedContinent] ?? "world"
        let path = db.collection("home").document("continents").collection(continentCode)
        
        path.getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Errore nel recupero dei dati: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Nessun documento trovato")
                return
            }
            
            self.places = documents.compactMap { document -> Place? in
                let data = document.data()
                return Place(
                    id: document.documentID,
                    name: data["name"] as? String ?? "",
                    country: data["country"] as? String ?? "",
                    region: data["region"] as? String ?? "",
                    rating: data["rating"] as? Double ?? 0.0,
                    imageUrl: data["imageUrl"] as? String ?? ""
                )
            }
        }
    }
}

struct Place: Identifiable, Decodable, Hashable, Equatable {
    let id: String
    let name: String
    let country: String
    let region: String
    let rating: Double
    let imageUrl: String
}
