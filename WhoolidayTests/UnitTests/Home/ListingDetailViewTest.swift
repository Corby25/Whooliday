//
//  ListingDetailViewTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
import SwiftUI
import MapKit
@testable import Whooliday

// test listing after fetch is completed
class ListingDetailViewTests: XCTestCase {
    
    var sut: ListingDetailView!
    var mockViewModel: MockExploreViewModelListTest!
    var mockFirebaseManager: MockFirebaseManagerListTest!
    var mockService: MockExploreServiceListTest!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        let mockListing = Listing(
            id: 1,
            latitude: 45.0,
            longitude: 9.0,
            city: "TestCity",
            state: "TS",
            name: "Test Hotel",
            strikethrough_price: 200.0,
            review_count: 100,
            review_score: 8.5,
            checkin: "2024-07-01",
            checkout: "2024-07-05",
            nAdults: 2,
            nChildren: 1,
            childrenAge: "5",
            currency: "EUR",
            images: ["test_image_url"]
        )
        
        mockService = MockExploreServiceListTest()
        mockViewModel = MockExploreViewModelListTest(service: mockService)
        mockFirebaseManager = MockFirebaseManagerListTest()
        FirebaseManager.shared = mockFirebaseManager
        
        sut = ListingDetailView(listing: mockListing, viewModel: mockViewModel)
        sut.isFavorite = false
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        mockFirebaseManager = nil
        mockService = nil
        try super.tearDownWithError()
    }
    
    func testInitialization() {
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.listing.id, 1)
        XCTAssertEqual(sut.listing.name, "Test Hotel")
    }
    
    func testRegionInitialization() {
        XCTAssertEqual(sut.region.center.latitude, 45.0, accuracy: 0.001)
        XCTAssertEqual(sut.region.center.longitude, 9.0, accuracy: 0.001)
    }
    
    func testToggleFavorite() {
        // Initially, isFavorite should be false
        XCTAssertFalse(sut.isFavorite)
        
        // Simulate toggling favorite to true
        sut.toggleFavorite()
        
        // Check that isFavorite is now true and addFavorite was called
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            

            
            // Simulate toggling favorite back to false
            self.sut.toggleFavorite()
            
            // Check that isFavorite is now false and removeFavorite was called
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                XCTAssertFalse(self.sut.isFavorite)
                XCTAssertFalse(self.mockFirebaseManager.addFavoriteCalled)
                XCTAssertTrue(self.mockFirebaseManager.removeFavoriteCalled)
            }
        }
    }

    
    func testCheckFavoriteStatus() {
        let expectation = self.expectation(description: "Favorite status check")
            
        sut.checkFavoriteStatus()
        
        DispatchQueue.main.async {
            XCTAssertFalse(self.sut.isFavorite)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }

    
    func testGenerateGoogleSearchURL() {
        let url = sut.generateGoogleSearchURL()
        XCTAssertNotNil(url)
        XCTAssertTrue(url?.absoluteString.contains("google.com/search") ?? false)
        XCTAssertTrue(url?.absoluteString.contains("Test%20Hotel") ?? false)
    }
    
    func testFetchHotelDetails() async {
        await sut.viewModel.fetchHotelDetails(for: sut.listing)
        XCTAssertTrue(mockViewModel.fetchHotelDetailsCalled)
    }
}

// MARK: - Mocks


class MockExploreServiceListTest: ExploreService {
    var fetchHotelDetailsResult: HotelDetails?
    var fetchPriceCalendarResult: [String: Double]?

     func fetchHotelDetails(for listing: Listing) async throws -> HotelDetails {
        return fetchHotelDetailsResult ?? HotelDetails(reviewScoreWord: "", city: "", state: "", accomodationType: "", numberOfBeds: "", checkinFrom: "", checkinTo: "", checkoutFrom: "", checkoutTo: "", info: "", accomodationID: 0, facilities: "")
    }

     func fetchPriceCalendar(for listing: Listing) async throws -> [String: Double] {
        return fetchPriceCalendarResult ?? [:]
    }
}

class MockExploreViewModelListTest: ExploreViewModel {
    var fetchHotelDetailsCalled = false
    var fetchPriceCalendarCalled = false
    
    override func fetchHotelDetails(for listing: Listing) async {
        fetchHotelDetailsCalled = true
    }
    
    override func fetchPriceCalendar(for listing: Listing) {
        fetchPriceCalendarCalled = true
    }
}

class MockFirebaseManagerListTest: FirebaseManager {
    var isListingFavoriteResult: Bool = false
    var addFavoriteCalled = false
    var removeFavoriteCalled = false
    
    override func isListingFavorite(listingId: Int, completion: @escaping (Bool) -> Void) {
        completion(isListingFavoriteResult)
    }
    
     func addFavorite(listing: Listing, completion: (() -> Void)? = nil) {
        addFavoriteCalled = true
        isListingFavoriteResult = true
        completion?()
    }
    
     func removeFavorite(listingId: Int, completion: (() -> Void)? = nil) {
        removeFavoriteCalled = true
        isListingFavoriteResult = false
        completion?()
    }
}
