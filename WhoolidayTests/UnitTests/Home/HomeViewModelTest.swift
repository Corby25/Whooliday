//
//  HomeViewModelTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 09/07/24.
//

import XCTest
import FirebaseFirestore
@testable import Whooliday

class HomeViewModelTests: XCTestCase {
    var viewModel: HomeViewModel!
    var mockFirestore: MockFirestore!

    override func setUp() {
        super.setUp()
        mockFirestore = MockFirestore()
        viewModel = HomeViewModel(db: mockFirestore)
    }

    override func tearDown() {
        viewModel = nil
        mockFirestore = nil
        super.tearDown()
    }

    func testInitialization() {
         XCTAssertEqual(viewModel.selectedContinent, "Mondo")
        
     }

    func testFetchPlaces() {
        // Prepare mock data
        let mockPlace = Place(id: "1", name: "Roma", country: "Italia", region: "Lazio", rating: 4.5, imageUrl: "roma.jpg", latitude: 41.9028, longitude: 12.4964, nLikes: 1000, description: "La Città Eterna")
        mockFirestore.mockPlaces = [mockPlace]

        // Fetch execution
        viewModel.fetchPlaces()

        // async operation
        let expectation = XCTestExpectation(description: "Fetch places")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.places.count, 1)
            XCTAssertEqual(self.viewModel.places.first?.name, "Roma")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 50.0)
    }

    func testToggleFavorite() {
        // mock data preparation
        let mockPlace = Place(id: "2", name: "Firenze", country: "Italia", region: "Toscana", rating: 4.5, imageUrl: "firenze.jpg", latitude: 41.9028, longitude: 12.4964, nLikes: 1000, description: "La Città Eterna")
        mockFirestore.mockPlaces = [mockPlace]
        viewModel.fetchPlaces()

        let expectation = XCTestExpectation(description: "Toggle favorite")

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // check initial state
            XCTAssertFalse(self.viewModel.isPlaceFavorite(mockPlace))
            XCTAssertEqual(self.viewModel.getUpdatedLikes(for: mockPlace), 1000)

            // add to favorite
            self.viewModel.toggleFavorite(for: mockPlace)
            XCTAssertTrue(self.viewModel.isPlaceFavorite(mockPlace))
            XCTAssertEqual(self.viewModel.getUpdatedLikes(for: mockPlace), 1001)

            // remove from favorites
            self.viewModel.toggleFavorite(for: mockPlace)
            XCTAssertFalse(self.viewModel.isPlaceFavorite(mockPlace))
            XCTAssertEqual(self.viewModel.getUpdatedLikes(for: mockPlace), 1000)

            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    func testUpdateLikeAndRating() {
        let mockDB = MockFirestore()
        let viewModel = HomeViewModel(db: mockDB)
        
        let testPlace = Place(id: "test", name: "Test Place", country: "Test Country", region: "Test Region", rating: 4.0, imageUrl: "", latitude: 0, longitude: 0, nLikes: 500, description: "Test description")
        
        viewModel.places = [testPlace]
        
        // Place not anymore into favorites
        viewModel.userFavorites.remove(testPlace.id)
        viewModel.userRatings[testPlace.id] = nil
        
        viewModel.updateLikeAndRating(for: testPlace, newRating: 5.0)
        
        XCTAssertEqual(viewModel.places[0].nLikes, 501, "Il numero di likes dovrebbe essere incrementato")
        XCTAssertGreaterThan(viewModel.places[0].rating, 4.0, "Il rating dovrebbe essere aumentato")
        XCTAssertEqual(viewModel.places[0].rating, 4.001996007984032, accuracy: 0.000001, "Il nuovo rating dovrebbe essere calcolato correttamente")
    }

    func testChangeSelectedContinent() {
        XCTAssertEqual(viewModel.selectedContinent, "Mondo")
        viewModel.selectedContinent = "Europa"
        XCTAssertEqual(viewModel.selectedContinent, "Europa")
    }
}

// MARK: - Mock Classes

class MockFirestore: FirestoreProtocol {
    var mockPlaces: [Place] = []

    func getCollection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return MockCollectionReference(places: mockPlaces)
    }
}

class MockCollectionReference: CollectionReferenceProtocol {
    var places: [Place]

    init(places: [Place]) {
        self.places = places
    }

    func document(_ documentPath: String) -> DocumentReferenceProtocol {
        return MockDocumentReference(place: places.first ?? Place(id: "", name: "", country: "", region: "", rating: 0, imageUrl: "", latitude: 0, longitude: 0, nLikes: 0, description: ""))
    }

    func getDocuments(completion: @escaping (QuerySnapshotProtocol?, Error?) -> Void) {
        let mockSnapshot = MockQuerySnapshot(places: places)
        completion(mockSnapshot, nil)
    }
}

class MockDocumentReference: DocumentReferenceProtocol {
    var place: Place

    init(place: Place) {
        self.place = place
    }

    func collection(_ collectionPath: String) -> CollectionReferenceProtocol {
        return MockCollectionReference(places: [self.place])
    }

    func updateData(_ data: [String : Any], completion: ((Error?) -> Void)?) {
        if let nLikes = data["nLikes"] as? Int {
            place.nLikes = nLikes
        }
        if let rating = data["rating"] as? Double {
            place.rating = rating
        }
        completion?(nil)
    }
}

class MockQuerySnapshot: QuerySnapshotProtocol {
    var documents: [QueryDocumentSnapshotProtocol]

    init(places: [Place]) {
        self.documents = places.map { MockQueryDocumentSnapshot(place: $0) }
    }
}

class MockQueryDocumentSnapshot: QueryDocumentSnapshotProtocol {
    var documentID: String
    private var placeData: [String: Any]

    init(place: Place) {
        self.documentID = place.id
        self.placeData = [
            "id": place.id,
            "name": place.name,
            "country": place.country,
            "region": place.region,
            "rating": place.rating,
            "imageUrl": place.imageUrl,
            "latitude": place.latitude,
            "longitude": place.longitude,
            "nLikes": place.nLikes,
            "description": place.description
        ]
    }

    func data() -> [String : Any] {
        return placeData
    }
}
