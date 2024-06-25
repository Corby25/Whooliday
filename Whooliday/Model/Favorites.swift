import FirebaseFirestoreSwift
import Foundation

struct Hotel: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    var hotelID: String
    var isNew: Bool
    var adultsNumber: Int
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

// Helper function to create a date
func createDate(year: Int, month: Int, day: Int) -> Date {
    let calendar = Calendar.current
    let components = DateComponents(year: year, month: month, day: day)
    return calendar.date(from: components) ?? Date()
}

let dummyHotels: [Hotel] = [
    Hotel(id: nil, hotelID: "H1001", isNew: true, adultsNumber: 2, checkIn: createDate(year: 2024, month: 7, day: 1), checkOut: createDate(year: 2024, month: 7, day: 5), newPrice: 200.0, oldPrice: 250.0, index: 1, isDeleted: false, name: "Hotel Sunshine", strikethroughPrice: 250.0, reviewCount: 150, reviewScore: 4.5, images: ["https://example.com/image1.jpg"]),
    Hotel(id: nil, hotelID: "H1002", isNew: false, adultsNumber: 2, checkIn: createDate(year: 2024, month: 7, day: 10), checkOut: createDate(year: 2024, month: 7, day: 15), newPrice: 180.0, oldPrice: 220.0, index: 2, isDeleted: false, name: "Hotel Paradise", strikethroughPrice: 220.0, reviewCount: 200, reviewScore: 4.3, images: ["https://example.com/image2.jpg"]),
    Hotel(id: nil, hotelID: "H1003", isNew: true, adultsNumber: 3, checkIn: createDate(year: 2024, month: 8, day: 1), checkOut: createDate(year: 2024, month: 8, day: 7), newPrice: 300.0, oldPrice: 350.0, index: 3, isDeleted: false, name: "Hotel Royal", strikethroughPrice: 350.0, reviewCount: 100, reviewScore: 4.7, images: ["https://example.com/image3.jpg"]),
    Hotel(id: nil, hotelID: "H1004", isNew: false, adultsNumber: 1, checkIn: createDate(year: 2024, month: 9, day: 5), checkOut: createDate(year: 2024, month: 9, day: 10), newPrice: 150.0, oldPrice: 180.0, index: 4, isDeleted: true, name: "Hotel Comfort", strikethroughPrice: 180.0, reviewCount: 250, reviewScore: 4.1, images: ["https://example.com/image4.jpg"]),
    Hotel(id: nil, hotelID: "H1005", isNew: true, adultsNumber: 4, checkIn: createDate(year: 2024, month: 10, day: 20), checkOut: createDate(year: 2024, month: 10, day: 25), newPrice: 400.0, oldPrice: 450.0, index: 5, isDeleted: false, name: "Hotel Elite", strikethroughPrice: 450.0, reviewCount: 300, reviewScore: 4.9, images: ["https://example.com/image5.jpg"]),
    Hotel(id: nil, hotelID: "H1006", isNew: false, adultsNumber: 2, checkIn: createDate(year: 2024, month: 11, day: 10), checkOut: createDate(year: 2024, month: 11, day: 15), newPrice: 220.0, oldPrice: 260.0, index: 6, isDeleted: true, name: "Hotel Bliss", strikethroughPrice: 260.0, reviewCount: 180, reviewScore: 4.4, images: ["https://example.com/image6.jpg"]),
    Hotel(id: nil, hotelID: "H1007", isNew: true, adultsNumber: 2, checkIn: createDate(year: 2024, month: 12, day: 1), checkOut: createDate(year: 2024, month: 12, day: 5), newPrice: 210.0, oldPrice: 260.0, index: 7, isDeleted: false, name: "Hotel Luxury", strikethroughPrice: 260.0, reviewCount: 120, reviewScore: 4.6, images: ["https://example.com/image7.jpg"]),
    Hotel(id: nil, hotelID: "H1008", isNew: false, adultsNumber: 3, checkIn: createDate(year: 2024, month: 12, day: 10), checkOut: createDate(year: 2024, month: 12, day: 15), newPrice: 180.0, oldPrice: 200.0, index: 8, isDeleted: false, name: "Hotel Plaza", strikethroughPrice: 200.0, reviewCount: 250, reviewScore: 4.2, images: ["https://example.com/image8.jpg"]),
    Hotel(id: nil, hotelID: "H1009", isNew: true, adultsNumber: 1, checkIn: createDate(year: 2024, month: 12, day: 20), checkOut: createDate(year: 2024, month: 12, day: 25), newPrice: 320.0, oldPrice: 370.0, index: 9, isDeleted: false, name: "Hotel Prestige", strikethroughPrice: 370.0, reviewCount: 170, reviewScore: 4.8, images: ["https://example.com/image9.jpg"])
]


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

struct Filter: Identifiable, Hashable {
    let id: String?
    let maxPrice: Double
    let numGuests: Int
    let latitude: Double
    let longitude: Double
    let adultsNumber: Int
    let orderBy: String
    let roomNumber: Int
    let units: String
    let checkIn: Date
    let checkOut: Date
    var isDeleted: Bool
    let index: Int
    var hotels: [Hotel]

    // Add this function to conform to Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(index)
    }

    // Add this function to conform to Equatable (required for Hashable)
    static func == (lhs: Filter, rhs: Filter) -> Bool {
        return lhs.id == rhs.id && lhs.index == rhs.index
    }
    
    mutating func updateHotels(_ newHotels: [Hotel]) {
            self.hotels = newHotels
        }
}
