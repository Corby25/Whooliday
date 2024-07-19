//
//  FirebaseManagerTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 09/07/24.
//

import XCTest
import FirebaseFirestore
import FirebaseAuth
import Combine
@testable import Whooliday


// test firebase
class FirebaseManagerTests: XCTestCase {
    
    var firebaseManager: FirebaseManager!
    var mockFirestoreManager: Firestore!
    var mockAuthManager: Auth!
    
    override func setUp() {
        super.setUp()
        mockFirestoreManager = Firestore.firestore()
        mockAuthManager = Auth.auth()
        firebaseManager = FirebaseManager.shared
    }
    
    override func tearDown() {
        firebaseManager = nil
        mockFirestoreManager = nil
        mockAuthManager = nil
        super.tearDown()
    }
    
    func testIsUserLoggedInManager() {
        // Test when user is logged in
        XCTAssertTrue(firebaseManager.isUserLoggedIn)
        
        
    }
    
    func testAddFavoriteManager() {
        let expectation = self.expectation(description: "Add favorite")
        
        let mockListing =  Listing(id: 1, latitude: 0.0, longitude: 0.0, city: "Rome", state: "Lazio", name: "Test Hotel", strikethrough_price: 200, review_count: 200, review_score: 4.0, checkin: "2024-08-10", checkout: "2024-08-15", nAdults: 3, nChildren: 2, childrenAge: "", currency: "EUR", images: [])
        
        firebaseManager.addFavorite(listing: mockListing)
        
        // You would need to mock the Firestore call and verify that the correct data was set
        // This is a simplified version
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testIsListingFavoriteManager() {
        let expectation = self.expectation(description: "Check if listing is favorite")
        
        firebaseManager.isListingFavorite(listingId: 1) { isFavorite in
            XCTAssertTrue(isFavorite)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testRemoveFavoriteManager() {
        let expectation = self.expectation(description: "Remove favorite")
        
        firebaseManager.removeFavorite(listingId: 1)
        
        // You would need to mock the Firestore call and verify that the correct document was deleted
        // This is a simplified version
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testGetFavoriteListingIdsManager() {
        let expectation = self.expectation(description: "Get favorite listing IDs")
        
        let cancellable = firebaseManager.getFavoriteListingIds()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
                }
                expectation.fulfill()
            }, receiveValue: { ids in
                XCTAssertFalse(ids.isEmpty)
            })
        
        waitForExpectations(timeout: 2.0, handler: nil)
        cancellable.cancel()
    }
    
    func testAddFavoriteFilterManager() {
        let expectation = self.expectation(description: "Add favorite filter")
        

        let mockListing =  Listing(id: 1, latitude: 0.0, longitude: 0.0, city: "Rome", state: "Lazio", name: "Test Hotel", strikethrough_price: 200, review_count: 200, review_score: 4.0, checkin: "2024-08-10", checkout: "2024-08-15", nAdults: 3, nChildren: 2, childrenAge: "", currency: "EUR", images: [])
        let appliedFilters = "price:100-200,rating:4"
        let mockListings = [mockListing]
        
        firebaseManager.addFavoriteFilter(listing: mockListing, appliedFilters: appliedFilters, listings: mockListings)
        
        // You would need to mock the Firestore calls and verify that the correct data was set
        // This is a simplified version
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    
}
