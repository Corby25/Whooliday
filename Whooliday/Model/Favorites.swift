import FirebaseFirestoreSwift
import Foundation

struct Hotel: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    var hotelID: String
    var isNew: Bool
    var adultsNumber: Int
    var childrenNumber: Int?
    let childrenAge: String?
    var checkIn: String
    var checkOut: String
    var newPrice: Double
    var oldPrice: Double
    var isDeleted: Bool

    // New fields from API
    var name: String?
    var strikethroughPrice: Double?
    var reviewCount: Int?
    var reviewScore: Double?
    var images: [String]?
    var latitude: Double?
    var longitude: Double?
    var city: String?
    var state: String?
}

// Helper function to create a date
func createDateString(year: Int, month: Int, day: Int) -> String {
    return String(format: "%04d-%02d-%02d", year, month, day)
}


let dummyHotels: [Hotel] = [
    Hotel(id: nil, hotelID: "H1001", isNew: true, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 7, day: 1), checkOut: createDateString(year: 2024, month: 7, day: 5), newPrice: 200.0, oldPrice: 250.0, isDeleted: false, name: "Hotel Sunshine", strikethroughPrice: 250.0, reviewCount: 150, reviewScore: 4.5, images: ["https://example.com/image1.jpg"], latitude: 37.7749, longitude: -122.4194, city: "San Francisco", state: "CA"),
    Hotel(id: nil, hotelID: "H1002", isNew: false, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 7, day: 10), checkOut: createDateString(year: 2024, month: 7, day: 15), newPrice: 180.0, oldPrice: 220.0, isDeleted: false, name: "Hotel Paradise", strikethroughPrice: 220.0, reviewCount: 200, reviewScore: 4.3, images: ["https://example.com/image2.jpg"], latitude: 34.0522, longitude: -118.2437, city: "Los Angeles", state: "CA"),
    Hotel(id: nil, hotelID: "H1003", isNew: true, adultsNumber: 3, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 8, day: 1), checkOut: createDateString(year: 2024, month: 8, day: 7), newPrice: 300.0, oldPrice: 350.0, isDeleted: false, name: "Hotel Royal", strikethroughPrice: 350.0, reviewCount: 100, reviewScore: 4.7, images: ["https://example.com/image3.jpg"], latitude: 40.7128, longitude: -74.0060, city: "New York", state: "NY"),
    Hotel(id: nil, hotelID: "H1004", isNew: false, adultsNumber: 1, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 9, day: 5), checkOut: createDateString(year: 2024, month: 9, day: 10), newPrice: 150.0, oldPrice: 180.0, isDeleted: true, name: "Hotel Comfort", strikethroughPrice: 180.0, reviewCount: 250, reviewScore: 4.1, images: ["https://example.com/image4.jpg"], latitude: 41.8781, longitude: -87.6298, city: "Chicago", state: "IL"),
    Hotel(id: nil, hotelID: "H1005", isNew: true, adultsNumber: 4, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 10, day: 20), checkOut: createDateString(year: 2024, month: 10, day: 25), newPrice: 400.0, oldPrice: 450.0, isDeleted: false, name: "Hotel Elite", strikethroughPrice: 450.0, reviewCount: 300, reviewScore: 4.9, images: ["https://example.com/image5.jpg"], latitude: 29.7604, longitude: -95.3698, city: "Houston", state: "TX"),
    Hotel(id: nil, hotelID: "H1006", isNew: false, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 11, day: 10), checkOut: createDateString(year: 2024, month: 11, day: 15), newPrice: 220.0, oldPrice: 260.0, isDeleted: true, name: "Hotel Bliss", strikethroughPrice: 260.0, reviewCount: 180, reviewScore: 4.4, images: ["https://example.com/image6.jpg"], latitude: 33.7490, longitude: -84.3880, city: "Atlanta", state: "GA"),
    Hotel(id: nil, hotelID: "H1007", isNew: true, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 12, day: 1), checkOut: createDateString(year: 2024, month: 12, day: 5), newPrice: 210.0, oldPrice: 260.0, isDeleted: false, name: "Hotel Luxury", strikethroughPrice: 260.0, reviewCount: 120, reviewScore: 4.6, images: ["https://example.com/image7.jpg"], latitude: 47.6062, longitude: -122.3321, city: "Seattle", state: "WA"),
    Hotel(id: nil, hotelID: "H1008", isNew: false, adultsNumber: 3, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 12, day: 10), checkOut: createDateString(year: 2024, month: 12, day: 15), newPrice: 180.0, oldPrice: 200.0, isDeleted: false, name: "Hotel Plaza", strikethroughPrice: 200.0, reviewCount: 250, reviewScore: 4.2, images: ["https://example.com/image8.jpg"], latitude: 34.0522, longitude: -118.2437, city: "Los Angeles", state: "CA"),
    Hotel(id: nil, hotelID: "H1009", isNew: true, adultsNumber: 1, childrenNumber: nil, childrenAge: nil, checkIn: createDateString(year: 2024, month: 12, day: 20), checkOut: createDateString(year: 2024, month: 12, day: 25), newPrice: 320.0, oldPrice: 370.0, isDeleted: false, name: "Hotel Prestige", strikethroughPrice: 370.0, reviewCount: 170, reviewScore: 4.8, images: ["https://example.com/image9.jpg"], latitude: 40.7128, longitude: -74.0060, city: "New York", state: "NY")
]


struct APIHotelResponse: Codable {
    var id: Int
    var latitude: Double
    var longitude: Double
    var name: String
    var strikethrough_price: Double?
    var review_count: Int?
    var review_score: Double?
    var city: String
    var state: String
    var images: [String]?

    func toHotel() -> Hotel {
        return Hotel(
            id: String(id),
            hotelID: String(id),
            isNew: false, // Update this accordingly
            adultsNumber: 0, // Update this accordingly
            childrenNumber: 0, // Update this accordingly
            childrenAge: "0",
            checkIn: String(),
            checkOut: String(),
            newPrice: 0.0,
            oldPrice: 0.0,
            isDeleted: false,
            name: name,
            strikethroughPrice: strikethrough_price,
            reviewCount: review_count,
            reviewScore: review_score,
            images: images,
            latitude: latitude,
            longitude: longitude,
            city: city,
            state: state
        )
    }
}

struct Filter: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    let maxPrice: Double
    let latitude: Double
    let longitude: Double
    let adultsNumber: Int
    let orderBy: String
    let roomNumber: Int
    let units: String
    let checkIn: String
    let checkOut: String
    let childrenNumber: Int
    let childrenAge: String
    let filters: String
    let city: String
    var isDeleted: Bool
    var isNew: Bool
    var hotels: [Hotel]
    
    mutating func updateHotels(_ newHotels: [Hotel]) {
            self.hotels = newHotels
        }
}
