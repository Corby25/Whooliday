//
//  CardViewBigTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
import SwiftUI
@testable import Whooliday

class CardViewBigTests: XCTestCase {

    func testCardViewBigInitialization() {
        // Create a sample Place
        let samplePlace = Place(
            id: "test123",
            name: "Test Place",
            country: "Test Country",
            region: "Test Region",
            rating: 4.7,
            imageUrl: "https://example.com/image.jpg",
            latitude: 0.0,
            longitude: 0.0,
            nLikes: 100,
            description: "Test description"
        )
        
        // Create the CardViewBig
        let cardView = CardViewBig(place: samplePlace)
        
        // Test that the place property is set correctly
        XCTAssertEqual(cardView.place.id, samplePlace.id)
        XCTAssertEqual(cardView.place.name, samplePlace.name)
        XCTAssertEqual(cardView.place.country, samplePlace.country)
        XCTAssertEqual(cardView.place.region, samplePlace.region)
        XCTAssertEqual(cardView.place.rating, samplePlace.rating)
        XCTAssertEqual(cardView.place.imageUrl, samplePlace.imageUrl)
    }

    func testCardViewBigColorScheme() {
        let samplePlace = Place(id: "test123", name: "Test Place", country: "Test Country", region: "Test Region", rating: 4.7, imageUrl: "https://example.com/image.jpg", latitude: 0.0, longitude: 0.0, nLikes: 100, description: "Test description")
        
        let lightSchemeView = CardViewBig(place: samplePlace)
            .environment(\.colorScheme, .light)
        
        let darkSchemeView = CardViewBig(place: samplePlace)
            .environment(\.colorScheme, .dark)
        
        // We can't directly test the appearance, but we can ensure different instances are created
        XCTAssertNotEqual(lightSchemeView.colorScheme, darkSchemeView.colorScheme)
    }
}
