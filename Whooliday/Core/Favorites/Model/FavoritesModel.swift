import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth

class FavoritesModel: ObservableObject {
    @Published var hotels: [Hotel] = []
    @Published var filters: [Filter] = []
    
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
        await fetchFilters()
    }
    
    
    private func fetchHotels() async {
        let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("hotels")
        
        // Start with index 1
        var index = 1
        var fetchNext = true
        
        while fetchNext {
            let hotelDocRef = hotelsCollectionRef.collection("hotel\(index)").document("hotel\(index)")
            
            do {
                // Attempt to get the document snapshot asynchronously
                let snapshot = try await hotelDocRef.getDocument()
                
                // Check if the document exists
                if snapshot.exists {
                    
                    // Attempt to decode hotel data from the snapshot
                    let hotelData = try? snapshot.data(as: Hotel.self)
                    
                    
                    DispatchQueue.main.async {self.hotels.append(hotelData!)}
                    
                    // Increment index for the next document
                    index += 1
                } else {
                    // No more documents found, stop fetching
                    fetchNext = false
                }
            } catch {
                print("Error fetching hotel\(index): \(error)")
                fetchNext = false
            }
        }
    }
    
    /*private func fetchFilters() async {
        let filtersCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters")
        
        // Start with index 1
        var index = 1
        var fetchNext = true
        
        while fetchNext {
            let filterDocRef = filtersCollectionRef.collection("filter\(index)").document("filter\(index)")
            
            do {
                // Attempt to get the document snapshot asynchronously
                let snapshot = try await filterDocRef.getDocument()
                
                // Check if the document exists
                if snapshot.exists {
                    print("Fetching filter \(index)")
                    
                    // Attempt to decode filter data from the snapshot
                    let filterData = try? snapshot.data(as: Filter.self)
                        // Update @Published property on the main thread
                        DispatchQueue.main.async {
                            self.filters.append(filterData!)
                        }
                        
                        // Fetch nested hotels for this filter if they exist
                    try? await fetchNestedHotels(for: filterData!)
                        
                        // Increment index for the next document
                        index += 1
                    
                } else {
                    // No more documents found, stop fetching
                    fetchNext = false
                }
            } catch {
                print("Error fetching filter \(index): \(error)")
                fetchNext = false
            }
        }
    }*/
    
    private func fetchFilters() async {
        let filtersCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters")
        
        // Start with index 1
        var index = 1
        var fetchNext = true
        
        while fetchNext {
            let filterDocRef = filtersCollectionRef.collection("filter\(index)").document("filter\(index)")
            
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
                              let currency = data["currency"] as? String,
                              let locale = data["locale"] as? String,
                              let orderBy = data["orderBy"] as? String,
                              let roomNumber = data["roomNumber"] as? Int,
                              let units = data["units"] as? String,
                              let checkInTimestamp = data["checkIn"] as? Timestamp,
                              let checkOutTimestamp = data["checkOut"] as? Timestamp else {
                            print("Failed to parse filter \(index) data.")
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
                                                currency: currency,
                                                locale: locale,
                                                orderBy: orderBy,
                                                roomNumber: roomNumber,
                                                units: units,
                                                checkIn: checkIn,
                                                checkOut: checkOut,
                                                hotels: []) // Initialize empty hotels array
                        
                        // Update @Published property on the main thread
                        DispatchQueue.main.async {
                            // Capture filterData immutably to avoid concurrency issues
                            self.filters.append(filterData)
                        }
                        
                        // Fetch nested hotels for this filter if they exist
                        try? await fetchNestedHotels(for: filterData)
                        
                        // Increment index for the next document
                        index += 1
                    } else {
                        print("Failed to decode filter \(index) data.")
                        fetchNext = false
                    }
                    
                } else {
                    // No more documents found, stop fetching
                    fetchNext = false
                }
                
            } catch {
                print("Error fetching filter \(index): \(error)")
                fetchNext = false
            }
        }
    }



    private func fetchNestedHotels(for filter: Filter) async throws {
        guard let filterID = filter.id else {
            print("Filter ID is nil, cannot fetch nested hotels.")
            return
        }
        
        let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters").collection(filterID).document(filterID).collection("hotels")
        
        // Start with index 1
        var index = 1
        var fetchNext = true
        
        while fetchNext {
            let hotelDocRef = hotelsCollectionRef.document("hotel\(index)")
            do {
                // Attempt to get the document snapshot asynchronously
                let snapshot = try await hotelDocRef.getDocument()
                
                // Check if the document exists
                if snapshot.exists {
                    // Attempt to decode hotel data from the snapshot
                    let hotelData = try? snapshot.data(as: Hotel.self)
                        // Handle the fetched hotel as needed
                        
                        // Update @Published property on the main thread
                    DispatchQueue.main.async {
                                        if let hotelData = hotelData {

                                            // Find the corresponding filter in self.filters and append the hotel ID
                                            if let filterIndex = self.filters.firstIndex(where: { $0.id == filterID }) {

                                                self.filters[filterIndex].hotels.append(hotelData)
                                            }
                                        }
                                    }
                        
                        // Increment index for the next document
                        index += 1
                    
                } else {
                    // No more documents found, stop fetching
                    fetchNext = false
                }
            } catch {
                print("Error fetching nested hotel for filter \(filterID): \(error)")
                fetchNext = false
                throw error // Propagate error up the call stack if needed
            }
        }
    }

}
