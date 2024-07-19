//
//  CountryTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday 

class CountryTests: XCTestCase {

    func testCountryInitialization() {
        let country = Country(name: "Test Country", alpha2Code: "tc")
        XCTAssertEqual(country.name, "Test Country")
        XCTAssertEqual(country.alpha2Code, "tc")
    }

    func testCountryEquality() {
        let country1 = Country(name: "Test Country", alpha2Code: "tc")
        let country2 = Country(name: "Test Country", alpha2Code: "tc")
        let country3 = Country(name: "Another Country", alpha2Code: "ac")

        XCTAssertEqual(country1, country2)
        XCTAssertNotEqual(country1, country3)
    }

    func testAllCountries() {
        let allCountries = Country.allCountries

       

        // Test for the presence of some specific countries
        XCTAssertTrue(allCountries.contains(where: { $0.name == "United States of America" && $0.alpha2Code == "us" }))
        XCTAssertTrue(allCountries.contains(where: { $0.name == "France" && $0.alpha2Code == "fr" }))
        XCTAssertTrue(allCountries.contains(where: { $0.name == "Japan" && $0.alpha2Code == "jp" }))

        // Test that all alpha2Codes are unique
        let alpha2Codes = allCountries.map { $0.alpha2Code }
        XCTAssertEqual(alpha2Codes.count, Set(alpha2Codes).count)

        // Test that all country names are unique
        let countryNames = allCountries.map { $0.name }
        XCTAssertEqual(countryNames.count, Set(countryNames).count)

        // Test that all alpha2Codes are lowercase and have exactly 2 characters
        XCTAssertTrue(allCountries.allSatisfy { $0.alpha2Code == $0.alpha2Code.lowercased() && $0.alpha2Code.count == 2 })
    }
}
