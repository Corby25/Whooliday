import FirebaseFirestoreSwift
import Foundation


struct Hotel: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    var hotelID: String
    var isNew: Bool
}

struct Filter: Identifiable, Codable {
    @DocumentID var id: String?
    var maxPrice: Double
    var numGuests: Int
    var latitude: Double
    var longitude: Double
    var adultsNumber: Int
    var currency: String
    var locale: String
    var orderBy: String
    var roomNumber: Int
    var units: String
    var checkIn: Date
    var checkOut: Date
    var hotels: [Hotel]
}
