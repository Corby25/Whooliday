import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth
import Foundation

class FavoritesModel: ObservableObject {
    @Published var hotels: [Hotel] = []
    @Published var filters: [Filter] = []
    @Published var isLoadingHotels = false
    @Published var isLoadingFilterHotels = false
    @Published var userCurrency: String = ""
    
    private var db = Firestore.firestore()
    private var userID: String

    
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
        Task {
            await fetchUserCurrency()
            await fetchFavorites()
        }
    }
    
    func fetchFavorites() async {
        await fetchHotels()
        await fetchFilters()
    }
    
    
    func fetchHotels() async {
        await MainActor.run {
            self.isLoadingHotels = true
        }
        
        let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("hotels").collection("all")
        
        do {
            let querySnapshot = try await hotelsCollectionRef.getDocuments()
            
            let processedHotels = await withTaskGroup(of: Hotel?.self) { group in
                for document in querySnapshot.documents {
                    group.addTask {
                        do {
                            var hotelData = try document.data(as: Hotel.self)
                            if let apiHotelData = await self.fetchHotelDetails(with: hotelData) {
                                hotelData.name = apiHotelData.name
                                hotelData.strikethroughPrice = apiHotelData.strikethrough_price
                                hotelData.reviewCount = apiHotelData.review_count
                                hotelData.reviewScore = apiHotelData.review_score
                                hotelData.images = apiHotelData.images
                                hotelData.latitude = apiHotelData.latitude
                                hotelData.longitude = apiHotelData.longitude
                                hotelData.city = apiHotelData.city
                                hotelData.state = apiHotelData.state
                            }
                            return hotelData
                        } catch {
                            print("Unable to decode document into HotelQueryParams")
                            print("Error: \(error)")
                            print("Document data:")
                            for (key, value) in document.data() {
                                print("\(key): \(value) (type: \(type(of: value)))")
                            }
                            return nil
                        }
                    }
                }
                
                var hotels: [Hotel] = []
                for await hotel in group {
                    if let hotel = hotel {
                        hotels.append(hotel)
                    }
                }
                return hotels
            }
            
            await MainActor.run {
                self.hotels.append(contentsOf: processedHotels)
            }
        } catch {
            print("Error fetching favorites: \(error.localizedDescription)")
        }
        
        await MainActor.run {
            self.isLoadingHotels = false
        }
    }


    private func fetchHotelDetails(with hotel: Hotel?) async -> APIHotelResponse? {
        let userDocRef = db.collection("users").document(userID)
        
        do {
            let userSnapshot = try await userDocRef.getDocument()
            
            if let userData = userSnapshot.data(),
               let currency = userData["currency"] as? String,
               let locale = userData["locale"] as? String {
                
                var components = URLComponents(string: "http://34.16.172.170:3000/api/fetchFullHotelByID")
                components?.queryItems = [
                    hotel?.childrenNumber != 0 ? URLQueryItem(name: "children_number", value: hotel?.childrenNumber.map { String($0) }) : nil,
                    URLQueryItem(name: "locale", value: locale),
                    hotel?.childrenNumber != 0 ? URLQueryItem(name: "children_ages", value: hotel?.childrenAge) : nil,
                    URLQueryItem(name: "filter_by_currency", value: currency),
                    URLQueryItem(name: "checkin_date", value: hotel?.checkIn),
                    URLQueryItem(name: "hotel_id", value: hotel?.hotelID),
                    URLQueryItem(name: "adults_number", value: String(hotel?.adultsNumber ?? 0)),
                    URLQueryItem(name: "checkout_date", value: hotel?.checkOut),
                    URLQueryItem(name: "units", value: "metric")
                ].compactMap { $0 }
                
                guard let url = components?.url else {
                    print("Invalid URL")
                    return nil
                }

                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(APIHotelResponse.self, from: data)
                print("Fetched hotel details from API")
                print(decodedResponse)
                return decodedResponse
            } else {
                print("Missing currency or locale information for user \(userID)")
                return nil
            }
        } catch {
            print("Error fetching hotel details")
            return nil
        }
    }
    
    
    private func fetchFilters() async {
        let filtersCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters").collection("all")
        
        do {
            let querySnapshot = try await filtersCollectionRef.getDocuments()
            
            let processedFilters = await withTaskGroup(of: Filter?.self) { group in
                for document in querySnapshot.documents {
                    group.addTask {
                        let data = document.data()
                        guard !data.isEmpty else {
                            print("No data found in document.")
                            return nil
                        }
                        
                        let id = document.documentID
                        
                        // Extract basic properties from the snapshot data
                        guard
                              let latitude = data["latitude"] as? Double,
                              let longitude = data["longitude"] as? Double,
                              let adultsNumber = data["adultsNumber"] as? Int,
                              let orderBy = data["orderBy"] as? String,
                              let roomNumber = data["roomNumber"] as? Int,
                              let units = data["units"] as? String,
                              let isDeleted = data["isDeleted"] as? Bool,
                              let isNew = data["isNew"] as? Bool,
                              let checkIn = data["checkIn"] as? String,
                              let checkOut = data["checkOut"] as? String,
                              let childrenNumber = data["childrenNumber"] as? Int,
                              let childrenAge = data["childrenAge"] as? String,
                              let city = data["city"] as? String,
                              let filters = data["filters"] as? String else {
                            print("Failed to parse filter data.")
                            return nil
                        }
                        
                        let maxPrice = Self.extractMaxPrice(from: filters)
                        
                        return Filter(id: id,
                                      maxPrice: maxPrice,
                                      latitude: latitude,
                                      longitude: longitude,
                                      adultsNumber: adultsNumber,
                                      orderBy: orderBy,
                                      roomNumber: roomNumber,
                                      units: units,
                                      checkIn: checkIn,
                                      checkOut: checkOut,
                                      childrenNumber: childrenNumber,
                                      childrenAge: childrenAge,
                                      filters: filters,
                                      city: city,
                                      isDeleted: isDeleted,
                                      isNew: isNew,
                                      hotels: [])
                    }
                }
                
                var results: [Filter] = []
                for await result in group {
                    if let filter = result {
                        results.append(filter)
                    }
                }
                return results
            }
            
            await MainActor.run {
                self.filters = processedFilters
            }
        } catch {
            print("Error fetching filters: \(error)")
        }
    }

    private static func extractMaxPrice(from filters: String) -> Double {
        let parts = filters.split(separator: ",")
        guard let firstPart = parts.first else { return 0 }
        
        let priceParts = firstPart.split(separator: "::")
        guard priceParts.count > 1 else { return 0 }
        
        let priceRange = priceParts[1].split(separator: "-")
        guard let maxPriceString = priceRange.last else { return 0 }
        
        return Double(maxPriceString) ?? 0
    }

    func fetchHotelsForFilter(_ filter: Filter) async {
        await MainActor.run {
            self.isLoadingFilterHotels = true
        }
        
        guard let filterID = filter.id else {
            print("Filter ID is nil, cannot fetch hotels.")
            await MainActor.run { self.isLoadingFilterHotels = false }
            return
        }

        let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters").collection("all").document(filterID).collection("hotels")
        
        do {
            let querySnapshot = try await hotelsCollectionRef.getDocuments()
            
            let processedHotels = await withTaskGroup(of: Hotel?.self) { group in
                for document in querySnapshot.documents {
                    group.addTask {
                        do {
                            var hotelData = try document.data(as: Hotel.self)
                            if let apiHotelData = await self.fetchHotelDetails(with: hotelData) {
                                hotelData.name = apiHotelData.name
                                hotelData.strikethroughPrice = apiHotelData.strikethrough_price
                                hotelData.reviewCount = apiHotelData.review_count
                                hotelData.reviewScore = apiHotelData.review_score
                                hotelData.images = apiHotelData.images
                                hotelData.latitude = apiHotelData.latitude
                                hotelData.longitude = apiHotelData.longitude
                                hotelData.city = apiHotelData.city
                                hotelData.state = apiHotelData.state
                            }
                            return hotelData
                        } catch {
                            print("Unable to decode document into Hotel")
                            print("Error: \(error)")
                            print("Document data:")
                            for (key, value) in document.data() {
                                print("\(key): \(value) (type: \(type(of: value)))")
                            }
                            return nil
                        }
                    }
                }
                
                var hotels: [Hotel] = []
                for await hotel in group {
                    if let hotel = hotel {
                        hotels.append(hotel)
                    }
                }
                return hotels
            }
            
            await MainActor.run {
                if let filterIndex = self.filters.firstIndex(where: { $0.id == filterID }) {
                    self.filters[filterIndex].hotels = processedHotels
                    print("Updated filter at index \(filterIndex) with \(processedHotels.count) hotels")
                    self.objectWillChange.send()
                } else {
                    print("Failed to find filter with ID: \(filterID)")
                }
                self.isLoadingFilterHotels = false
            }
        } catch {
            await MainActor.run {
                print("Error fetching hotels for filter: \(error.localizedDescription)")
                self.isLoadingFilterHotels = false
            }
        }
    }
    
    

    func deleteHotel(_ hotel: Hotel) {
        let hotelCollectionRef = db.collection("users").document(userID)
                                   .collection("favorites").document("hotels").collection("all")
        
        // Query to find the document with the matching hotelID
        hotelCollectionRef.whereField("hotelID", isEqualTo: hotel.hotelID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding document: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No document found with the specified hotelID")
                return
            }
            
            // Assuming there's only one document with the matching hotelID
            let document = documents[0]
            let documentID = document.documentID
            
            // Update the document's isDeleted field
            hotelCollectionRef.document(documentID).updateData(["isDeleted": true]) { error in
                if let error = error {
                    print("Error updating document: \(error.localizedDescription)")
                } else {
                    print("Document successfully updated to mark as deleted")
                    // Optionally remove the hotel from the local array
                    DispatchQueue.main.async {
                        if let index = self.hotels.firstIndex(where: { $0.hotelID == hotel.hotelID }) {
                            self.hotels[index].isDeleted = true
                        }
                    }
                }
            }
        }
    }

    
    func deleteFilter(withId id: String) {
        let filterDocumentRef = db.collection("users").document(userID)
            .collection("favorites").document("filters").collection("all").document(id)
        
        filterDocumentRef.updateData(["isDeleted": true]) { [weak self] error in
            if let error = error {
                print("Error updating filter document: \(error.localizedDescription)")
            } else {
                print("Filter document successfully updated to mark as deleted")
                DispatchQueue.main.async {
                    if let index = self?.filters.firstIndex(where: { $0.id == id }) {
                        self?.filters[index].isDeleted = true
                        self?.objectWillChange.send()
                    }
                }
            }
        }
    }
    
    func markFilterAsNotNew(withId id: String) {
        let filterDocumentRef = db.collection("users").document(userID)
            .collection("favorites").document("filters").collection("all").document(id)
        
        filterDocumentRef.updateData(["isNew": false]) { [weak self] error in
            if let error = error {
                print("Error updating filter document: \(error.localizedDescription)")
            } else {
                print("Filter document successfully updated to mark as not new")
                DispatchQueue.main.async {
                    if let index = self?.filters.firstIndex(where: { $0.id == id }) {
                        self?.filters[index].isNew = false
                        self?.objectWillChange.send()
                    }
                }
            }
        }
    }

    func refreshHotels() async {
        DispatchQueue.main.async {
            self.hotels.removeAll()
        }
        await fetchHotels()
    }

    func refreshFilters() async {
        DispatchQueue.main.async {
            self.filters.removeAll()
        }
        await fetchFilters()
    }
    
    private func fetchUserCurrency() async {
        let userDocRef = db.collection("users").document(userID)
        do {
            let userSnapshot = try await userDocRef.getDocument()
            if let userData = userSnapshot.data(),
               let currency = userData["currency"] as? String {
                await MainActor.run {
                    self.userCurrency = currency
                }
            }
        } catch {
            print("Error fetching user currency: \(error.localizedDescription)")
        }
    }
}
