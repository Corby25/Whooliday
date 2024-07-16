//
//  UserTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday // Replace with your actual module name

class UserTests: XCTestCase {

    func testUserInitialization() {
        let user = User(
            id: "123",
            name: "John Doe",
            email: "john@example.com",
            currency: "USD",
            locale: "en_US",
            numNotifications: 5,
            numFavorites: 10,
            sendEmail: true
        )

        XCTAssertEqual(user.id, "123")
        XCTAssertEqual(user.name, "John Doe")
        XCTAssertEqual(user.email, "john@example.com")
        XCTAssertEqual(user.currency, "USD")
        XCTAssertEqual(user.locale, "en_US")
        XCTAssertEqual(user.numNotifications, 5)
        XCTAssertEqual(user.numFavorites, 10)
        XCTAssertTrue(user.sendEmail)
    }

    func testInitials() {
        let user1 = User(id: "1", name: "John Doe", email: "", currency: "", locale: "", numNotifications: 0, numFavorites: 0, sendEmail: false)
        XCTAssertEqual(user1.initials, "JD")

        let user2 = User(id: "2", name: "Alice", email: "", currency: "", locale: "", numNotifications: 0, numFavorites: 0, sendEmail: false)
        XCTAssertEqual(user2.initials, "A")

        let user3 = User(id: "3", name: "Robert John Smith", email: "", currency: "", locale: "", numNotifications: 0, numFavorites: 0, sendEmail: false)
        XCTAssertEqual(user3.initials, "RS")

        let user4 = User(id: "4", name: "", email: "", currency: "", locale: "", numNotifications: 0, numFavorites: 0, sendEmail: false)
        XCTAssertEqual(user4.initials, "")
    }

    func testUserCoding() {
        let user = User(
            id: "123",
            name: "John Doe",
            email: "john@example.com",
            currency: "USD",
            locale: "en_US",
            numNotifications: 5,
            numFavorites: 10,
            sendEmail: true
        )

        let encoder = JSONEncoder()
        let decoder = JSONDecoder()

        do {
            let encodedData = try encoder.encode(user)
            let decodedUser = try decoder.decode(User.self, from: encodedData)

            XCTAssertEqual(user.id, decodedUser.id)
            XCTAssertEqual(user.name, decodedUser.name)
            XCTAssertEqual(user.email, decodedUser.email)
            XCTAssertEqual(user.currency, decodedUser.currency)
            XCTAssertEqual(user.locale, decodedUser.locale)
            XCTAssertEqual(user.numNotifications, decodedUser.numNotifications)
            XCTAssertEqual(user.numFavorites, decodedUser.numFavorites)
            XCTAssertEqual(user.sendEmail, decodedUser.sendEmail)
        } catch {
            XCTFail("Failed to encode or decode User: \(error)")
        }
    }
}
