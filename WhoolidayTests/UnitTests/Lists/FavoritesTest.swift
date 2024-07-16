//
//  FavoritesTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday
import FirebaseFirestoreSwift

class HotelAndFilterTests: XCTestCase {

    func testHotelInitialization() {
        let hotel = Hotel(
            id: "1",
            hotelID: "H1001",
            isNew: true,
            adultsNumber: 2,
            childrenNumber: 1,
            childrenAge: "5",
            checkIn: "2024-07-01",
            checkOut: "2024-07-05",
            newPrice: 200.0,
            oldPrice: 250.0,
            isDeleted: false,
            name: "Test Hotel",
            strikethroughPrice: 250.0,
            reviewCount: 100,
            reviewScore: 4.5,
            images: ["image1.jpg", "image2.jpg"],
            latitude: 37.7749,
            longitude: -122.4194,
            city: "San Francisco",
            state: "CA"
        )

        XCTAssertEqual(hotel.id, "1")
        XCTAssertEqual(hotel.hotelID, "H1001")
        XCTAssertTrue(hotel.isNew)
        XCTAssertEqual(hotel.adultsNumber, 2)
        XCTAssertEqual(hotel.childrenNumber, 1)
        XCTAssertEqual(hotel.childrenAge, "5")
        XCTAssertEqual(hotel.checkIn, "2024-07-01")
        XCTAssertEqual(hotel.checkOut, "2024-07-05")
        XCTAssertEqual(hotel.newPrice, 200.0)
        XCTAssertEqual(hotel.oldPrice, 250.0)
        XCTAssertFalse(hotel.isDeleted)
        XCTAssertEqual(hotel.name, "Test Hotel")
        XCTAssertEqual(hotel.strikethroughPrice, 250.0)
        XCTAssertEqual(hotel.reviewCount, 100)
        XCTAssertEqual(hotel.reviewScore, 4.5)
        XCTAssertEqual(hotel.images, ["image1.jpg", "image2.jpg"])
        XCTAssertEqual(hotel.latitude, 37.7749)
        XCTAssertEqual(hotel.longitude, -122.4194)
        XCTAssertEqual(hotel.city, "San Francisco")
        XCTAssertEqual(hotel.state, "CA")
    }

    func testCreateDateString() {
        XCTAssertEqual(createDateString(year: 2024, month: 7, day: 1), "2024-07-01")
        XCTAssertEqual(createDateString(year: 2024, month: 12, day: 31), "2024-12-31")
    }

    func testAPIHotelResponseToHotel() {
        let apiResponse = APIHotelResponse(
            id: 1001,
            latitude: 37.7749,
            longitude: -122.4194,
            name: "API Hotel",
            strikethrough_price: 300.0,
            review_count: 200,
            review_score: 4.7,
            city: "San Francisco",
            state: "CA",
            images: ["api_image1.jpg", "api_image2.jpg"]
        )

        let hotel = apiResponse.toHotel()

        XCTAssertEqual(hotel.id, "1001")
        XCTAssertEqual(hotel.hotelID, "1001")
        XCTAssertFalse(hotel.isNew)
        XCTAssertEqual(hotel.adultsNumber, 0)
        XCTAssertEqual(hotel.childrenNumber, 0)
        XCTAssertEqual(hotel.childrenAge, "0")
        XCTAssertEqual(hotel.checkIn, "")
        XCTAssertEqual(hotel.checkOut, "")
        XCTAssertEqual(hotel.newPrice, 0.0)
        XCTAssertEqual(hotel.oldPrice, 0.0)
        XCTAssertFalse(hotel.isDeleted)
        XCTAssertEqual(hotel.name, "API Hotel")
        XCTAssertEqual(hotel.strikethroughPrice, 300.0)
        XCTAssertEqual(hotel.reviewCount, 200)
        XCTAssertEqual(hotel.reviewScore, 4.7)
        XCTAssertEqual(hotel.images, ["api_image1.jpg", "api_image2.jpg"])
        XCTAssertEqual(hotel.latitude, 37.7749)
        XCTAssertEqual(hotel.longitude, -122.4194)
        XCTAssertEqual(hotel.city, "San Francisco")
        XCTAssertEqual(hotel.state, "CA")
    }

    func testFilterInitialization() {
        let hotels = [Hotel(id: "1", hotelID: "H1", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2024-07-01", checkOut: "2024-07-05", newPrice: 200.0, oldPrice: 250.0, isDeleted: false)]
        
        let filter = Filter(
            id: "F1",
            maxPrice: 300.0,
            latitude: 37.7749,
            longitude: -122.4194,
            adultsNumber: 2,
            orderBy: "price",
            roomNumber: 1,
            units: "USD",
            checkIn: "2024-07-01",
            checkOut: "2024-07-05",
            childrenNumber: 0,
            childrenAge: "",
            filters: "pool,wifi",
            city: "San Francisco",
            isDeleted: false,
            isNew: true,
            hotels: hotels
        )

        XCTAssertEqual(filter.id, "F1")
        XCTAssertEqual(filter.maxPrice, 300.0)
        XCTAssertEqual(filter.latitude, 37.7749)
        XCTAssertEqual(filter.longitude, -122.4194)
        XCTAssertEqual(filter.adultsNumber, 2)
        XCTAssertEqual(filter.orderBy, "price")
        XCTAssertEqual(filter.roomNumber, 1)
        XCTAssertEqual(filter.units, "USD")
        XCTAssertEqual(filter.checkIn, "2024-07-01")
        XCTAssertEqual(filter.checkOut, "2024-07-05")
        XCTAssertEqual(filter.childrenNumber, 0)
        XCTAssertEqual(filter.childrenAge, "")
        XCTAssertEqual(filter.filters, "pool,wifi")
        XCTAssertEqual(filter.city, "San Francisco")
        XCTAssertFalse(filter.isDeleted)
        XCTAssertTrue(filter.isNew)
        XCTAssertEqual(filter.hotels.count, 1)
        XCTAssertEqual(filter.hotels.first?.hotelID, "H1")
    }

    func testFilterUpdateHotels() {
        var filter = Filter(id: "F1", maxPrice: 300.0, latitude: 0, longitude: 0, adultsNumber: 2, orderBy: "", roomNumber: 1, units: "", checkIn: "", checkOut: "", childrenNumber: 0, childrenAge: "", filters: "", city: "", isDeleted: false, isNew: true, hotels: [])
        
        let newHotels = [
            Hotel(id: "1", hotelID: "H1", isNew: true, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2024-07-01", checkOut: "2024-07-05", newPrice: 200.0, oldPrice: 250.0, isDeleted: false),
            Hotel(id: "2", hotelID: "H2", isNew: false, adultsNumber: 2, childrenNumber: 0, childrenAge: nil, checkIn: "2024-07-01", checkOut: "2024-07-05", newPrice: 180.0, oldPrice: 220.0, isDeleted: false)
        ]
        
        filter.updateHotels(newHotels)
        
        XCTAssertEqual(filter.hotels.count, 2)
        XCTAssertEqual(filter.hotels[0].hotelID, "H1")
        XCTAssertEqual(filter.hotels[1].hotelID, "H2")
    }
}
