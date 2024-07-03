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
    
    private var db = Firestore.firestore()
    private var userID: String

    
    init() {
        self.userID = Auth.auth().currentUser?.uid ?? ""
        Task {
            await fetchFavorites()
        }
    }
    
    func fetchFavorites() async {
        await fetchHotels()
        //await fetchFilters()
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


    private func fetchHotelDetails(with hotel: Hotel?) async -> Listing? {
        let userDocRef = db.collection("users").document(userID)
        
        do {
            let userSnapshot = try await userDocRef.getDocument()
            
            if let userData = userSnapshot.data(),
               let currency = userData["currency"] as? String,
               let locale = userData["locale"] as? String {
                
                var components = URLComponents(string: "http://34.16.172.170:3000/api/fetchHotelByID")
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
                print(url)
                
                let (data, _) = try await URLSession.shared.data(from: url)
                let decodedResponse = try JSONDecoder().decode(APIHotelResponse.self, from: data)
                print("Fetched hotel details from API")
                
                return Listing(
                    id: decodedResponse.id,
                    latitude: decodedResponse.latitude,
                    longitude: decodedResponse.longitude,
                    city: "",
                    state: "",
                    name: decodedResponse.name,
                    strikethrough_price: hotel?.newPrice ?? 0,
                    review_count: decodedResponse.review_count ?? 0,
                    review_score: decodedResponse.review_score ?? 0.0,
                    checkin: "",
                    checkout: "",
                    nAdults: 0,
                    nChildren: 0,
                    childrenAge: "",
                    currency: "",
                    images: decodedResponse.images ?? []
                )
            } else {
                print("Missing currency or locale information for user \(userID)")
                return nil
            }
        } catch {
            print("Error fetching user data for \(userID): \(error)")
            return nil
        }
    }

    
    
    private func dateToString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    private func fetchFilters() async {
        let filtersCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters")
        
        // Start with index 1
        var indexWhile = 1
        var fetchNext = true
        
        while fetchNext {
            let filterDocRef = filtersCollectionRef.collection("filter\(indexWhile)").document("filter\(indexWhile)")
            
            do {
                // Attempt to get the document snapshot asynchronously
                let snapshot = try await filterDocRef.getDocument()
                
                // Check if the document exists
                if snapshot.exists {
                    
                    // Attempt to decode basic filter data from the snapshot
                    if let data = snapshot.data() {
                        // Extract basic properties from the snapshot data
                        guard let maxPrice = data["maxPrice"] as? Double,
                              let numGuests = data["numGuests"] as? Int,
                              let latitude = data["latitude"] as? Double,
                              let longitude = data["longitude"] as? Double,
                              let adultsNumber = data["adultsNumber"] as? Int,
                              let orderBy = data["orderBy"] as? String,
                              let roomNumber = data["roomNumber"] as? Int,
                              let units = data["units"] as? String,
                              let isDeleted = data["isDeleted"] as? Bool,
                              let index = data["index"] as? Int,
                              let checkInTimestamp = data["checkIn"] as? Timestamp,
                              let checkOutTimestamp = data["checkOut"] as? Timestamp else {
                            print("Failed to parse filter \(indexWhile) data.")
                            fetchNext = false
                            continue
                        }
                        let checkIn = checkInTimestamp.dateValue() // Convert Timestamp to Date
                        let checkOut = checkOutTimestamp.dateValue() // Convert Timestamp to Date
                                            
                        // Create a Filter object with basic properties
                        let filterData = Filter(id: snapshot.documentID,
                                                maxPrice: maxPrice,
                                                numGuests: numGuests,
                                                latitude: latitude,
                                                longitude: longitude,
                                                adultsNumber: adultsNumber,
                                                orderBy: orderBy,
                                                roomNumber: roomNumber,
                                                units: units,
                                                checkIn: checkIn,
                                                checkOut: checkOut,
                                                isDeleted: isDeleted,
                                                index: index,
                                                hotels: []) // Initialize empty hotels array
                        
                        // Update @Published property on the main thread
                        DispatchQueue.main.async {
                            // Capture filterData immutably to avoid concurrency issues
                            self.filters.append(filterData)
                        }
                        
                        // Increment index for the next document
                        indexWhile += 1
                    } else {
                        print("Failed to decode filter \(indexWhile) data.")
                        fetchNext = false
                    }
                    
                } else {
                    // No more documents found, stop fetching
                    fetchNext = false
                }
                
            } catch {
                print("Error fetching filter \(indexWhile): \(error)")
                fetchNext = false
            }
        }
    }

    func fetchHotelsForFilter(_ filter: Filter) async {
        /*DispatchQueue.main.async {
            self.isLoadingFilterHotels = true
        }
            guard let filterID = filter.id else {
                print("Filter ID is nil, cannot fetch hotels.")
                return
            }

            let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters").collection(filterID).document(filterID).collection("hotels")
            
            var index = 1
            var fetchNext = true
            var fetchedHotels: [Hotel] = []

            while fetchNext {
                let hotelDocRef = hotelsCollectionRef.document("hotel\(index)")
                do {
                    let snapshot = try await hotelDocRef.getDocument()
                    
                    if snapshot.exists {
                        var hotelData = try snapshot.data(as: Hotel.self)
                        
                        if let apiHotelData = await fetchHotelDetails(from: hotelData) {
                            hotelData.name = apiHotelData.name
                            hotelData.strikethroughPrice = apiHotelData.strikethrough_price
                            hotelData.reviewCount = apiHotelData.review_count
                            hotelData.reviewScore = apiHotelData.review_score
                            hotelData.images = apiHotelData.images
                        }
                        
                        fetchedHotels.append(hotelData)
                        index += 1
                    } else {
                        fetchNext = false
                    }
                } catch {
                    print("Error fetching hotel for filter \(filterID): \(error)")
                    fetchNext = false
                }
            }

            DispatchQueue.main.async {
                if let filterIndex = self.filters.firstIndex(where: { $0.id == filterID }) {
                    self.filters[filterIndex].hotels = fetchedHotels
                    print("Updated filter at index \(filterIndex) with \(fetchedHotels.count) hotels")
                    self.objectWillChange.send()

                    
                }else {
                    print("Failed to find filter with ID: \(filterID)")}
                self.isLoadingFilterHotels = false
            }
        */}
    
    

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

    
    func deleteFilter(at index: Int) {
        let indexInDb = index + 1
        let filterDocumentRef = db.collection("users").document(userID)
                                  .collection("favorites").document("filters").collection("filter\(String(indexInDb))").document("filter\(String(indexInDb))")

        filterDocumentRef.updateData(["isDeleted": true]) { error in
            if let error = error {
                print("Error updating filter document: \(error.localizedDescription)")
            } else {
                print("Filter document successfully updated to mark as deleted")
                DispatchQueue.main.async {
                    // Update locally and notify UI
                    self.filters.remove(at: index)
                    //self.filters[index].isDeleted = true
                    self.objectWillChange.send()
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
}
