//
//  ListingTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday 

class ListingTests: XCTestCase {

    func testListingInitialization() {
        let listing = Listing(
            id: 1,
            latitude: 40.7128,
            longitude: -74.0060,
            city: "New York",
            state: "NY",
            name: "Cozy Apartment",
            strikethrough_price: 150.0,
            review_count: 100,
            review_score: 4.5,
            checkin: "14:00",
            checkout: "11:00",
            nAdults: 2,
            nChildren: 1,
            childrenAge: "5",
            currency: "USD",
            images: ["image1.jpg", "image2.jpg"]
        )

        XCTAssertEqual(listing.id, 1)
        XCTAssertEqual(listing.latitude, 40.7128)
        XCTAssertEqual(listing.longitude, -74.0060)
        XCTAssertEqual(listing.city, "New York")
        XCTAssertEqual(listing.state, "NY")
        XCTAssertEqual(listing.name, "Cozy Apartment")
        XCTAssertEqual(listing.strikethrough_price, 150.0)
        XCTAssertEqual(listing.review_count, 100)
        XCTAssertEqual(listing.review_score, 4.5)
        XCTAssertEqual(listing.checkin, "14:00")
        XCTAssertEqual(listing.checkout, "11:00")
        XCTAssertEqual(listing.nAdults, 2)
        XCTAssertEqual(listing.nChildren, 1)
        XCTAssertEqual(listing.childrenAge, "5")
        XCTAssertEqual(listing.currency, "USD")
        XCTAssertEqual(listing.images, ["image1.jpg", "image2.jpg"])
    }

    func testPriceComputation() {
        let listing1 = Listing(id: 1, latitude: 0, longitude: 0, city: "", state: "", name: "", strikethrough_price: 100.0, review_count: 0, review_score: 0, checkin: "", checkout: "", nAdults: 0, nChildren: nil, childrenAge: nil, currency: "", images: [])
        XCTAssertEqual(listing1.price, 100.0)

        let listing2 = Listing(id: 2, latitude: 0, longitude: 0, city: "", state: "", name: "", strikethrough_price: -1, review_count: 0, review_score: 0, checkin: "", checkout: "", nAdults: 0, nChildren: nil, childrenAge: nil, currency: "", images: [])
        XCTAssertEqual(listing2.price, 0.0)
    }

    func testListingEquality() {
        let listing1 = Listing(id: 1, latitude: 0, longitude: 0, city: "", state: "", name: "", strikethrough_price: 100.0, review_count: 0, review_score: 0, checkin: "", checkout: "", nAdults: 0, nChildren: nil, childrenAge: nil, currency: "", images: [])
        let listing2 = Listing(id: 1, latitude: 0, longitude: 0, city: "", state: "", name: "", strikethrough_price: 100.0, review_count: 0, review_score: 0, checkin: "", checkout: "", nAdults: 0, nChildren: nil, childrenAge: nil, currency: "", images: [])
        let listing3 = Listing(id: 2, latitude: 0, longitude: 0, city: "", state: "", name: "", strikethrough_price: 100.0, review_count: 0, review_score: 0, checkin: "", checkout: "", nAdults: 0, nChildren: nil, childrenAge: nil, currency: "", images: [])

        XCTAssertEqual(listing1, listing2)
        XCTAssertNotEqual(listing1, listing3)
    }

    func testListingDecoding() {
        let json = """
        {
            "id": 1,
            "latitude": 40.7128,
            "longitude": -74.0060,
            "city": "New York",
            "state": "NY",
            "name": "Cozy Apartment",
            "strikethrough_price": 150.0,
            "review_count": 100,
            "review_score": 4.5,
            "checkin": "14:00",
            "checkout": "11:00",
            "nAdults": 2,
            "nChildren": 1,
            "childrenAge": "5",
            "currency": "USD",
            "images": ["image1.jpg", "image2.jpg"]
        }
        """

        let jsonData = json.data(using: .utf8)!
        let decoder = JSONDecoder()

        do {
            let listing = try decoder.decode(Listing.self, from: jsonData)
            XCTAssertEqual(listing.id, 1)
            XCTAssertEqual(listing.name, "Cozy Apartment")
            XCTAssertEqual(listing.price, 150.0)
        } catch {
            XCTFail("Failed to decode Listing: \(error)")
        }
    }
}
