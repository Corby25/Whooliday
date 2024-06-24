import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth
import Foundation

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
    
    
    private func fetchHotels() async{
        let hotelsCollectionRef = db.collection("users").document(userID).collection("favorites").document("hotels")
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
                    var hotelData = try snapshot.data(as: Hotel.self)
                    
                    // Fetch additional details from the API
                    if let apiHotelData = await fetchHotelDetails(from: hotelData) {
                        hotelData.name = apiHotelData.name
                        hotelData.strikethroughPrice = apiHotelData.strikethrough_price
                        hotelData.reviewCount = apiHotelData.review_count
                        hotelData.reviewScore = apiHotelData.review_score
                        hotelData.images = apiHotelData.images
                    }
                        
                        DispatchQueue.main.async {
                            self.hotels.append(hotelData)
                        }

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


    private func fetchHotelDetails(from hotel: Hotel) async -> Listing? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let checkInDate = dateFormatter.string(from: hotel.checkIn)
        let checkOutDate = dateFormatter.string(from: hotel.checkOut)

        let urlString = "http://34.16.172.170:3000/api/fetchHotelByID?locale=it&filter_by_currency=\(hotel.currency)&checkin_date=\(checkInDate)&hotel_id=\(hotel.hotelID)&adults_number=\(hotel.adultsNumber)&checkout_date=\(checkOutDate)&units=metric"

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedResponse = try JSONDecoder().decode(APIHotelResponse.self, from: data)
            print("fetched")
            return Listing(
                id: decodedResponse.id,
                latitude: decodedResponse.latitude,
                longitude: decodedResponse.longitude,
                name: decodedResponse.name,
                strikethrough_price: hotel.newPrice,
                review_count: decodedResponse.review_count ?? 0,
                review_score: decodedResponse.review_score ?? 0.0,
                images: decodedResponse.images ?? []
            )
        } catch {
            print("Error fetching hotel details from API: \(error)")
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
                              let currency = data["currency"] as? String,
                              let locale = data["locale"] as? String,
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
                                                currency: currency,
                                                locale: locale,
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
                        
                        // Fetch nested hotels for this filter if they exist
                        try? await fetchNestedHotels(for: filterData)
                        
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
                    var hotelData = try snapshot.data(as: Hotel.self)
                    
                    // Fetch additional details from the API
                    if let apiHotelData = await fetchHotelDetails(from: hotelData) {
                        hotelData.name = apiHotelData.name
                        hotelData.strikethroughPrice = apiHotelData.strikethrough_price
                        hotelData.reviewCount = apiHotelData.review_count
                        hotelData.reviewScore = apiHotelData.review_score
                        hotelData.images = apiHotelData.images
                    }
                    
                    DispatchQueue.main.async {
                        // Find the corresponding filter in self.filters and append the hotel data
                        if let filterIndex = self.filters.firstIndex(where: { $0.id == filterID }) {
                            self.filters[filterIndex].hotels.append(hotelData)
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
    

    func deleteHotel(_ hotel: Hotel) {
        let indexString = String(hotel.index)
        let hotelDocumentRef = db.collection("users").document(userID)
                                 .collection("favorites").document("hotels").collection("hotel\(indexString)")
                                 .document("hotel\(indexString)")
        
        hotelDocumentRef.updateData(["isDeleted": true]) { error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                print("Document successfully updated to mark as deleted")
                // Optionally remove the hotel from the local array
                DispatchQueue.main.async {
                    print(hotel.index)
                    self.hotels[hotel.index-1].isDeleted = true
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
                    print(index)
                    self.filters[index].isDeleted = true
                }
            }
        }
    }

}
