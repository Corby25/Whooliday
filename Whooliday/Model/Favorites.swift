import FirebaseFirestoreSwift

struct Hotel: Identifiable, Codable {
    @DocumentID var id: String? // Use DocumentID to automatically map Firestore document ID
    var hotelID: String
    var isNew: Bool
}

struct Filter: Identifiable, Codable {
    @DocumentID var id: String?
    var maxPrice: Double
    var numGuests: Int
    var x: Double
    var y: Double
    var hotels: [Hotel]
}

