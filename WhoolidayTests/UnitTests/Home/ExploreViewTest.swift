//
//  ExploreViewTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest
@testable import Whooliday
import SwiftUI

// test explore view class
class ExploreViewTests: XCTestCase {

    var sut: ExploreView!
    var mockExploreViewModel: ExploreViewModel!
    var mockExploreService: MockExploreService!
    var mockHotelDetailsService: MockHotelDetailsService!

    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockExploreService = MockExploreService()
        mockHotelDetailsService = MockHotelDetailsService()
        mockExploreViewModel = ExploreViewModel(service: mockExploreService, hotelDetailsService: mockHotelDetailsService)
        let searchParameters = SearchParameters(destination: "Roma", placeID: "ChIJu46S-ZZhLxMROG5lkwZ3D7k", startDate: Date(), endDate: Date().addingTimeInterval(86400 * 7), numAdults: 2, numChildren: 0, childrenAges: [])
        sut = ExploreView(searchParameters: searchParameters)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockExploreViewModel = nil
        mockExploreService = nil
        mockHotelDetailsService = nil
        try super.tearDownWithError()
    }

    func testExploreViewInitialization() {
        XCTAssertNotNil(sut, "ExploreView should be initialized")
        XCTAssertEqual(sut.searchParameters.destination, "Roma", "Destination should be set correctly")
    }

    
    // add favorites
    func testToggleFavorite() {
        sut.isFavorite = true
        sut.toggleFavorite()
        sleep(1)
        XCTAssertFalse(sut.getIsFavorite(), "toggleFavorite should toggle isFavorite")
    }
    
    // test successfull search
    @MainActor
    func testPerformSearchType() async {
        sut.selectedPropertyType = "Hotel"
        sut.selectedTypeID = 1
        await sut.performSearchType()
        XCTAssertFalse(sut.viewModel.isLoading, "performSearchType should set isLoading to false when completed")
    }

    func testSaveSearch() {
        let listing = Listing(id: 1, latitude: 41.9028, longitude: 12.4964, city: "Roma", state: "IT", name: "Test Hotel", strikethrough_price: 100.0, review_count: 100, review_score: 4.0, checkin: "2024-07-01", checkout: "2024-07-05", nAdults: 2, nChildren: 0, childrenAge: "", currency: "EUR", images: [])
        sut.viewModel.listings = [listing]
        sut.saveSearch()
        
    }
}
