//
//  HomeViewModel.swift
//  Whooliday
//
//  Created by Fabio Tagliani on 26/06/24.
//
import SwiftUI
import MapKit
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
    
    private var userFavorites: Set<String> = []
    private var userRatings: [String: Double] = [:]
    
    init() {
        fetchPlaces()
        loadUserPreferences()
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
                    imageUrl: data["imageUrl"] as? String ?? "",
                    latitude: data["latitute"] as? Double ?? 0.0,
                    longitude: data["longitude"] as? Double ?? 0.0,
                    nLikes: data["nLikes"] as? Int ?? 0,
                    description: data["description"] as? String ?? ""
                )
            }
        }
    }
    
    func updateLikeAndRating(for place: Place, newRating: Double) {
        guard let index = places.firstIndex(where: { $0.id == place.id }) else { return }
        
        let oldRating = userRatings[place.id] ?? 0
        let wasLiked = userFavorites.contains(place.id)
        
        // Aggiorna il modello locale
        if !wasLiked {
            places[index].nLikes += 1
            userFavorites.insert(place.id)
        }
        
        if oldRating == 0 {
            places[index].rating = (places[index].rating * Double(places[index].nLikes - 1) + newRating) / Double(places[index].nLikes)
        } else {
            places[index].rating = (places[index].rating * Double(places[index].nLikes) - oldRating + newRating) / Double(places[index].nLikes)
        }
        
        userRatings[place.id] = newRating
        
        // Aggiorna il database
        let continentCode = continentMapping[selectedContinent] ?? "world"
        let docRef = db.collection("home").document("continents").collection(continentCode).document(place.id)
        
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
        if userFavorites.contains(place.id) {
            userFavorites.remove(place.id)
            if let index = places.firstIndex(where: { $0.id == place.id }) {
                places[index].nLikes -= 1
            }
        } else {
            userFavorites.insert(place.id)
            if let index = places.firstIndex(where: { $0.id == place.id }) {
                places[index].nLikes += 1
            }
        }
        
        saveUserPreferences()
        updatePlaceInDatabase(place)
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
        let docRef = db.collection("home").document("continents").collection(continentCode).document(place.id)
        
        docRef.updateData([
            "nLikes": getUpdatedLikes(for: place)
        ]) { error in
            if let error = error {
                print("Errore nell'aggiornamento del documento: \(error)")
            }
        }
    }


    @Published var monthlyAverageTemperatures: [MonthlyTemperature] = []
      @Published var errorMessage: String?
      private let weatherService = WeatherService()

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
