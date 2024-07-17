//
//  HomeViewModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//
import SwiftUI
import MapKit
import FirebaseFirestore


// HomePage model
class HomeViewModel: ObservableObject {
    @Published var places: [Place] = []
    @Published var selectedContinent: String = "Mondo"
    @Published var errorState: ErrorState?
    @Published var errorMessage: String?
    var userFavorites: Set<String> = []
    var userRatings: [String: Double] = [:]
    
    enum ErrorState: Identifiable {
        case networkError
        
        var id: String { String(describing: self) }
        var message: String {
            switch self {
            case .networkError:
                return "Si è verificato un errore di connessione. Riprova più tardi."
            }
        }
    }
    
    private let db: FirestoreProtocol
    private let weatherService = WeatherService()
    
    private let continentMapping = [
        "Mondo": "world",
        "Europa": "europe",
        "Asia": "asia",
        "America": "americas",
        "Africa": "africa",
        "Antartide": "antartide",
        "Oceania": "oceania"
    ]
    
    
    
    
    init(db: FirestoreProtocol = Firestore.firestore()) {
        self.db = db
        fetchPlaces()
        loadUserPreferences()
    }
    
    
    // fetch static places for the db
    func fetchPlaces() {
        let continentCode = continentMapping[selectedContinent] ?? "world"
        let path = db.getCollection("home").document("continents").collection(continentCode)
        
        path.getDocuments { [weak self] (querySnapshot, error) in
            guard let self = self else { return }
            
            if let error = error {
                print("Errore nel recupero dei dati: \(error)")
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                    self.places = []  // Pulisci l'array dei luoghi in caso di errore
                }
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("Nessun documento trovato")
                DispatchQueue.main.async {
                    self.errorState = .networkError
                }
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
                    imageUrl: data["imageUrl"] as? String ?? "",
                    latitude: data["latitude"] as? Double ?? 0.0,
                    longitude: data["longitude"] as? Double ?? 0.0,
                    nLikes: data["nLikes"] as? Int ?? 0,
                    description: data["description"] as? String ?? ""
                )
            }
            
            DispatchQueue.main.async {
                self.errorState = nil
            }
            DispatchQueue.main.async {
                self.errorMessage = nil
            }
        }
    }
    
    // update like and ranking
    func updateLikeAndRating(for place: Place, newRating: Double) {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else { return }
        
        let oldRating = userRatings[place.id] ?? 0
        let wasLiked = userFavorites.contains(place.id)
        
        // update local model
        if !wasLiked {
            places[index].nLikes += 1
            userFavorites.insert(place.id)
        }
        
        // here to update rating, only last rate is valid
        let totalRatings = Double(places[index].nLikes)
        if oldRating == 0 {
            
            places[index].rating = ((places[index].rating * (totalRatings - 1)) + newRating) / totalRatings
        } else {
            places[index].rating = ((places[index].rating * totalRatings) - oldRating + newRating) / totalRatings
        }
        
        userRatings[place.id] = newRating
        
        // update the db
        let continentCode = continentMapping[selectedContinent] ?? "world"
        let docRef = db.getCollection("home").document("continents").collection(continentCode).document(place.id)
        
        docRef.updateData([
            "nLikes": places[index].nLikes,
            "rating": places[index].rating
        ]) { error in
            if let error = error {
                print("Errore nell'aggiornamento del documento: \(error)")
            }
        }
        
        saveUserPreferences()
    }
    
    func isPlaceFavorite(_ place: Place) -> Bool {
        return userFavorites.contains(place.id)
    }
    
    func getUserRating(for place: Place) -> Double {
        return userRatings[place.id] ?? 0
    }
    
    func toggleFavorite(for place: Place) {
        if let index = places.firstIndex(where: { $0.id == place.id }) {
            if userFavorites.contains(place.id) {
                userFavorites.remove(place.id)
                places[index].nLikes -= 1
            } else {
                userFavorites.insert(place.id)
                places[index].nLikes += 1
            }
            
            saveUserPreferences()
            updatePlaceInDatabase(places[index])
        }
    }
    
    func getUpdatedRating(for place: Place) -> Double {
        return places.first(where: { $0.id == place.id })?.rating ?? place.rating
    }
    
    func getUpdatedLikes(for place: Place) -> Int {
        return places.first(where: { $0.id == place.id })?.nLikes ?? place.nLikes
    }
    
    
    private func loadUserPreferences() {
        if let favorites = UserDefaults.standard.array(forKey: "userFavorites") as? [String] {
            userFavorites = Set(favorites)
        }
        if let ratings = UserDefaults.standard.dictionary(forKey: "userRatings") as? [String: Double] {
            userRatings = ratings
        }
    }
    
    private func saveUserPreferences() {
        UserDefaults.standard.set(Array(userFavorites), forKey: "userFavorites")
        UserDefaults.standard.set(userRatings, forKey: "userRatings")
    }
    
    private func updatePlaceInDatabase(_ place: Place) {
        let continentCode = continentMapping[selectedContinent] ?? "world"
        let docRef = db.getCollection("home").document("continents").collection(continentCode).document(place.id)
        
        docRef.updateData([
            "nLikes": getUpdatedLikes(for: place)
        ]) { error in
            if let error = error {
                print("Errore nell'aggiornamento del documento: \(error)")
            }
        }
    }
    
    func retryFetchPlaces() {
        errorState = nil
        fetchPlaces()
    }
    
    @Published var monthlyAverageTemperatures: [MonthlyTemperature] = []
    
    // api to fetch average temperatures
    func fetchWeatherData(latitude: Double, longitude: Double) async {
        do {
            let response = try await weatherService.fetchWeatherData(latitude: latitude, longitude: longitude)
            let averages = weatherService.calculateMonthlyAverages(from: response)
            DispatchQueue.main.async {
                self.monthlyAverageTemperatures = averages
                self.errorMessage = nil
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
struct Place: Identifiable {
    let id: String
    let name: String
    let country: String
    let region: String
    var rating: Double
    let imageUrl: String
    let latitude: Double
    let longitude: Double
    var nLikes: Int
    let description: String
    var monthlyTemperatures: [MonthlyTemperature]?
    
    init(id: String, name: String, country: String, region: String, rating: Double, imageUrl: String, latitude: Double, longitude: Double, nLikes: Int, description: String) {
        self.id = id
        self.name = name
        self.country = country
        self.region = region
        self.rating = rating
        self.imageUrl = imageUrl
        self.latitude = latitude
        self.longitude = longitude
        self.nLikes = nLikes
        self.description = description
        self.monthlyTemperatures = nil
    }
}

protocol FirestoreProtocol {
    func getCollection(_ collectionPath: String) -> CollectionReferenceProtocol
}

protocol CollectionReferenceProtocol: AnyObject {
    func document(_ documentPath: String) -> DocumentReferenceProtocol
    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void)
}

protocol DocumentReferenceProtocol: AnyObject {
    func collection(_ collectionPath: String) -> CollectionReferenceProtocol
    func updateData(_ data: [String: Any], completion: ((Error?) -> Void)?)
}

protocol QuerySnapshotProtocol {
    var documents: [QueryDocumentSnapshotProtocol] { get }
}

protocol QueryDocumentSnapshotProtocol {
    var documentID: String { get }
    func data() -> [String: Any]
}

extension Firestore: FirestoreProtocol {
    func getCollection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return FirestoreCollectionReferenceAdapter(self.collection(collectionPath))
    }
}

class FirestoreCollectionReferenceAdapter: CollectionReferenceProtocol {
    private let collectionReference: CollectionReference
    
    init(_ collectionReference: CollectionReference) {
        self.collectionReference = collectionReference
    }
    
    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return FirestoreDocumentReferenceAdapter(collectionReference.document(documentPath))
    }
    
    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
        collectionReference.getDocuments { (snapshot, error) in
            completion(snapshot.map(FirestoreQuerySnapshotAdapter.init), error)
        }
    }
}

class FirestoreDocumentReferenceAdapter: DocumentReferenceProtocol {
    func collection(_ collectionPath: String) -> any CollectionReferenceProtocol {
        return FirestoreCollectionReferenceAdapter(documentReference.collection(collectionPath))
    }
    
    private let documentReference: DocumentReference
    
    init(_ documentReference: DocumentReference) {
        self.documentReference = documentReference
    }
    
    func getCollection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return FirestoreCollectionReferenceAdapter(documentReference.collection(collectionPath))
    }
    
    func updateData(_ data: [String : Any], completion: ((Error?) -> Void)?) {
        documentReference.updateData(data, completion: completion)
    }
}

class FirestoreQuerySnapshotAdapter: QuerySnapshotProtocol {
    private let querySnapshot: QuerySnapshot
    
    init(_ querySnapshot: QuerySnapshot) {
        self.querySnapshot = querySnapshot
    }
    
    var documents: [QueryDocumentSnapshotProtocol] {
        return querySnapshot.documents.map(FirestoreQueryDocumentSnapshotAdapter.init)
    }
}

class FirestoreQueryDocumentSnapshotAdapter: QueryDocumentSnapshotProtocol {
    private let queryDocumentSnapshot: QueryDocumentSnapshot
    
    init(_ queryDocumentSnapshot: QueryDocumentSnapshot) {
        self.queryDocumentSnapshot = queryDocumentSnapshot
    }
    
    var documentID: String {
        return queryDocumentSnapshot.documentID
    }
    
    func data() -> [String : Any] {
        return queryDocumentSnapshot.data()
    }
}
