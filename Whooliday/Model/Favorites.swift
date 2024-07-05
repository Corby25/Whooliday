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
}

// Helper function to create a date
func createDate(year: Int, month: Int, day: Int) -> Date {
    let calendar = Calendar.current
    let components = DateComponents(year: year, month: month, day: day)
    return calendar.date(from: components) ?? Date()
}

let dummyHotels: [Hotel] = [
    Hotel(id: nil, hotelID: "H1001", isNew: true, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: "2024-07-01", checkOut: "2024-07-05", newPrice: 200.0, oldPrice: 250.0,  isDeleted: false, name: "Hotel Sunshine", strikethroughPrice: 250.0, reviewCount: 150, reviewScore: 4.5, images: ["https://example.com/image1.jpg"]),
    Hotel(id: nil, hotelID: "H1002", isNew: false, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: "2024-07-10", checkOut: "2024-07-15", newPrice: 180.0, oldPrice: 220.0,  isDeleted: false, name: "Hotel Paradise", strikethroughPrice: 220.0, reviewCount: 200, reviewScore: 4.3, images: ["https://example.com/image2.jpg"]),
    Hotel(id: nil, hotelID: "H1003", isNew: true, adultsNumber: 3, childrenNumber: nil, childrenAge: nil, checkIn: "2024-08-01", checkOut: "2024-08-07", newPrice: 300.0, oldPrice: 350.0,  isDeleted: false, name: "Hotel Royal", strikethroughPrice: 350.0, reviewCount: 100, reviewScore: 4.7, images: ["https://example.com/image3.jpg"]),
    Hotel(id: nil, hotelID: "H1004", isNew: false, adultsNumber: 1, childrenNumber: nil, childrenAge: nil, checkIn: "2024-09-05", checkOut: "2024-09-10", newPrice: 150.0, oldPrice: 180.0,  isDeleted: true, name: "Hotel Comfort", strikethroughPrice: 180.0, reviewCount: 250, reviewScore: 4.1, images: ["https://example.com/image4.jpg"]),
    Hotel(id: nil, hotelID: "H1005", isNew: true, adultsNumber: 4, childrenNumber: nil, childrenAge: nil, checkIn: "2024-10-20", checkOut: "2024-10-25", newPrice: 400.0, oldPrice: 450.0,  isDeleted: false, name: "Hotel Elite", strikethroughPrice: 450.0, reviewCount: 300, reviewScore: 4.9, images: ["https://example.com/image5.jpg"]),
    Hotel(id: nil, hotelID: "H1006", isNew: false, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: "2024-11-10", checkOut: "2024-11-15", newPrice: 220.0, oldPrice: 260.0,  isDeleted: true, name: "Hotel Bliss", strikethroughPrice: 260.0, reviewCount: 180, reviewScore: 4.4, images: ["https://example.com/image6.jpg"]),
    Hotel(id: nil, hotelID: "H1007", isNew: true, adultsNumber: 2, childrenNumber: nil, childrenAge: nil, checkIn: "2024-12-01", checkOut: "2024-12-05", newPrice: 210.0, oldPrice: 260.0,  isDeleted: false, name: "Hotel Luxury", strikethroughPrice: 260.0, reviewCount: 120, reviewScore: 4.6, images: ["https://example.com/image7.jpg"]),
    Hotel(id: nil, hotelID: "H1008", isNew: false, adultsNumber: 3, childrenNumber: nil, childrenAge: nil, checkIn: "2024-12-10", checkOut: "2024-12-15", newPrice: 180.0, oldPrice: 200.0,  isDeleted: false, name: "Hotel Plaza", strikethroughPrice: 200.0, reviewCount: 250, reviewScore: 4.2, images: ["https://example.com/image8.jpg"]),
    Hotel(id: nil, hotelID: "H1009", isNew: true, adultsNumber: 1, childrenNumber: nil, childrenAge: nil, checkIn: "2024-12-20", checkOut: "2024-12-25", newPrice: 320.0, oldPrice: 370.0,  isDeleted: false, name: "Hotel Prestige", strikethroughPrice: 370.0, reviewCount: 170, reviewScore: 4.8, images: ["https://example.com/image9.jpg"])
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
            images: images
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
    var hotels: [Hotel]
    
    mutating func updateHotels(_ newHotels: [Hotel]) {
            self.hotels = newHotels
        }
}
