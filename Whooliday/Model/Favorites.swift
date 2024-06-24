import FirebaseFirestoreSwift
import Foundation

struct Hotel: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    var hotelID: String
    var isNew: Bool
    var adultsNumber: Int
    var currency: String
    var checkIn: Date
    var checkOut: Date
    var newPrice: Double
    var oldPrice: Double
    var index: Int
    var isDeleted: Bool

    // New fields from API
    var name: String?
    var strikethroughPrice: Double?
    var reviewCount: Int?
    var reviewScore: Double?
    var images: [String]?
}


struct APIHotelResponse: Codable {
    var id: Int
    var latitude: Double
    var longitude: Double
    var name: String
    var strikethrough_price: Double?
    var review_count: Int?
    var review_score: Double?
    var images: [String]?

    func toHotel() -> Hotel {
        return Hotel(
            id: String(id),
            hotelID: String(id),
            isNew: false, // Update this accordingly
            adultsNumber: 0, // Update this accordingly
            currency: "",
            checkIn: Date(),
            checkOut: Date(),
            newPrice: 0.0,
            oldPrice: 0.0,
            index: 100,
            isDeleted: false,
            name: name,
            strikethroughPrice: strikethrough_price,
            reviewCount: review_count,
            reviewScore: review_score,
            images: images
        )
    }
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
