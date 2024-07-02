import FirebaseFirestore
import FirebaseFirestoreSwift
import Combine
import FirebaseAuth
import Foundation

@MainActor
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
        await fetchFilters()
    }
    
    func fetchHotels() async {
        isLoadingHotels = true
        
        let favoritesCollectionRef = db.collection("users").document(userID).collection("favorites").document("hotels").collection("all")
        
        do {
            let querySnapshot = try await favoritesCollectionRef.getDocuments()
            
            var newHotels: [Hotel] = []
            
            for document in querySnapshot.documents {
                do {
                    let hotelData = try document.data(as: Hotel.self)
                    
                    if let apiHotelData = await fetchHotelDetails(from: hotelData) {
                        var updatedHotel = hotelData
                        updatedHotel.name = apiHotelData.name
                        updatedHotel.strikethroughPrice = apiHotelData.strikethrough_price
                        updatedHotel.reviewCount = apiHotelData.review_count
                        updatedHotel.reviewScore = apiHotelData.review_score
                        updatedHotel.images = apiHotelData.images
                        
                        newHotels.append(updatedHotel)
                    } else {
                        newHotels.append(hotelData)
                    }
                } catch {
                    print("Error decoding hotel data: \(error)")
                }
            }
            
            self.hotels = newHotels
        } catch {
            print("Error fetching hotels: \(error)")
        }
        
        isLoadingHotels = false
    }

    
    private func fetchHotelDetails(from hotel: Hotel?) async -> Listing? {
        guard let hotel = hotel else { return nil }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let checkInDate = dateFormatter.string(from: hotel.checkIn)
        let checkOutDate = dateFormatter.string(from: hotel.checkOut)
        
        let userDocRef = db.collection("users").document(userID)
        
        do {
            let userSnapshot = try await userDocRef.getDocument()
            
            if let userData = userSnapshot.data(),
               let currency = userData["currency"] as? String,
               let locale = userData["locale"] as? String {
                
                let urlString = "http://34.16.172.170:3000/api/fetchHotelByID?locale=\(locale)&filter_by_currency=\(currency)&checkin_date=\(checkInDate)&hotel_id=\(hotel.hotelID)&adults_number=\(hotel.adultsNumber)&checkout_date=\(checkOutDate)&units=metric"
                
                guard let url = URL(string: urlString) else {
                    print("Invalid URL: \(urlString)")
                    return nil
                }
                
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
                    strikethrough_price: hotel.newPrice,
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

    private func fetchFilters() async {
        /*
        let filtersCollectionRef = db.collection("users").document(userID).collection("favorites").document("filters")
        
        var indexWhile = 1
        var fetchNext = true
        var newFilters: [Filter] = []
        
        while fetchNext {
            let filterDocRef = filtersCollectionRef.collection("filter\(indexWhile)").document("filter\(indexWhile)")
            
            do {
                let snapshot = try await filterDocRef.getDocument()
                
                if snapshot.exists, let data = snapshot.data() {
                    // ... (estrazione dei dati dal documento)
                    
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
                    newFilters.append(filterData)
                    
                    indexWhile += 1
                } else {
                    fetchNext = false
                }
            } catch {
                print("Error fetching filter \(indexWhile): \(error)")
                fetchNext = false
            }
        }
        
        self.filters = newFilters
         */
    }

    func fetchHotelsForFilter(_ filter: Filter) async {
        isLoadingFilterHotels = true
        
        guard let filterID = filter.id else {
            print("Filter ID is nil, cannot fetch hotels.")
            isLoadingFilterHotels = false
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
                    let hotelData = try snapshot.data(as: Hotel.self)
                    
                    if let apiHotelData = await fetchHotelDetails(from: hotelData) {
                        var updatedHotel = hotelData
                        updatedHotel.name = apiHotelData.name
                        updatedHotel.strikethroughPrice = apiHotelData.strikethrough_price
                        updatedHotel.reviewCount = apiHotelData.review_count
                        updatedHotel.reviewScore = apiHotelData.review_score
                        updatedHotel.images = apiHotelData.images
                        
                        fetchedHotels.append(updatedHotel)
                    } else {
                        fetchedHotels.append(hotelData)
                    }
                    
                    index += 1
                } else {
                    fetchNext = false
                }
            } catch {
                print("Error fetching hotel for filter \(filterID): \(error)")
                fetchNext = false
            }
        }

        if let filterIndex = self.filters.firstIndex(where: { $0.id == filterID }) {
            self.filters[filterIndex].hotels = fetchedHotels
            print("Updated filter at index \(filterIndex) with \(fetchedHotels.count) hotels")
        } else {
            print("Failed to find filter with ID: \(filterID)")
        }
        
        isLoadingFilterHotels = false
    }

    func deleteHotel(_ hotel: Hotel) {
        Task {
            let indexString = String(hotel.index)
            let hotelDocumentRef = db.collection("users").document(userID)
                                     .collection("favorites").document("hotels").collection("hotel\(indexString)")
                                     .document("hotel\(indexString)")
            
            do {
                try await hotelDocumentRef.updateData(["isDeleted": true])
                print("Document successfully updated to mark as deleted")
                if let index = self.hotels.firstIndex(where: { $0.index == hotel.index }) {
                    self.hotels[index].isDeleted = true
                }
            } catch {
                print("Error updating document: \(error.localizedDescription)")
            }
        }
    }
    
    func deleteFilter(at index: Int) {
        Task {
            let indexInDb = index + 1
            let filterDocumentRef = db.collection("users").document(userID)
                                      .collection("favorites").document("filters").collection("filter\(String(indexInDb))").document("filter\(String(indexInDb))")

            do {
                try await filterDocumentRef.updateData(["isDeleted": true])
                print("Filter document successfully updated to mark as deleted")
                self.filters.remove(at: index)
            } catch {
                print("Error updating filter document: \(error.localizedDescription)")
            }
        }
    }
    
    func refreshHotels() async {
        self.hotels.removeAll()
        self.isLoadingHotels = true
        await fetchHotels()
    }

    func refreshFilters() async {
        self.filters.removeAll()
        await fetchFilters()
    }
}



