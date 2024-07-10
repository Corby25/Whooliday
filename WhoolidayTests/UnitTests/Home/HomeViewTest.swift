//
//  HomeViewTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
@testable import Whooliday
import SwiftUI

class HomeViewTests: XCTestCase {
    
    var sut: HomeView!
    var mockViewModel: HomeViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockViewModel = HomeViewModel.mock()
        sut = HomeView(viewModel: mockViewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        mockViewModel = nil
        try super.tearDownWithError()
    }

    func testInitialization() {
        XCTAssertNotNil(sut, "HomeView should be initialized")
        XCTAssertNotNil(sut.viewModel, "ViewModel should be initialized")
    }
    
    func testPlacesCount() {
        XCTAssertEqual(sut.viewModel.places.count, 5, "There should be 5 places in the mock data")
    }
    
    func testSelectedContinent() {
        XCTAssertEqual(sut.viewModel.selectedContinent, "Mondo", "Initially selected continent should be 'Mondo'")
    }
    
    func testCardViewCreation() {
        let view = sut.body
        let cardViewBig = view.findViewWithAccessibilityIdentifier("CardViewBig")
        XCTAssertNotNil(cardViewBig, "CardViewBig should exist in the body")
        
        let searchAndFilterBar = view.findViewWithAccessibilityIdentifier("SearchAndFilterBar")
        XCTAssertNotNil(searchAndFilterBar, "SearchAndFilterBar should exist in the body")
    }
    
    func testDestinationSearchOverlay() {
        // Arrange
        sut.showDestinationSearch = true
        
        // Act
        let view = sut.body
        
        // Assert
        let destinationSearchView = view.findViewWithAccessibilityIdentifier("DestinationSearchView")
        XCTAssertNotNil(destinationSearchView, "DestinationSearchView should exist when showDestinationSearch is true")
    }
    
    func testNavigationDestination() {
        // Arrange
        sut.navigateToExplore = true
        sut.searchParameters = SearchParameters(destination: "Test Destination", placeID: "123", startDate: Date(), endDate: Date(), numAdults: 2, numChildren: 0, childrenAges: [])

        // Act
        let view = sut.body

        // Assert
        let expectation = XCTestExpectation(description: "Navigation update")
        DispatchQueue.main.async {
            let exploreView = view.findViewWithAccessibilityIdentifier("ExploreView")
            XCTAssertNotNil(exploreView, "ExploreView should exist when navigateToExplore is true")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1.0)
    }
    
    
}

extension View {
    func findViewWithAccessibilityIdentifier(_ identifier: String) -> some View {
        return self.accessibility(identifier: identifier)
    }
}
