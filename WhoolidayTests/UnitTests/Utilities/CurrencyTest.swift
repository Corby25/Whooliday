//
//  CurrencyTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday // Replace with your actual module name

class CurrencyTests: XCTestCase {

    func testCurrencyInitialization() {
        let currency = Currency(name: "Test Currency", alpha2Code: "TST")
        XCTAssertEqual(currency.name, "Test Currency")
        XCTAssertEqual(currency.alpha2Code, "TST")
    }

    func testCurrencyEquality() {
        let currency1 = Currency(name: "Test Currency", alpha2Code: "TST")
        let currency2 = Currency(name: "Test Currency", alpha2Code: "TST")
        let currency3 = Currency(name: "Another Currency", alpha2Code: "ANC")

        XCTAssertEqual(currency1, currency2)
        XCTAssertNotEqual(currency1, currency3)
    }

    func testAllCurrencies() {
        let allCurrencies = Currency.allCurrencies



        // Test for the presence of some specific currencies
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "United States Dollar" && $0.alpha2Code == "USD" }))
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "Euro" && $0.alpha2Code == "EUR" }))
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "Japanese Yen" && $0.alpha2Code == "JPY" }))

        // Test that all currency codes are unique
        let currencyCodes = allCurrencies.map { $0.alpha2Code }
        XCTAssertEqual(currencyCodes.count, Set(currencyCodes).count)

        // Test that all currency names are unique
        let currencyNames = allCurrencies.map { $0.name }
        XCTAssertEqual(currencyNames.count, Set(currencyNames).count)

        // Test that all currency codes are uppercase and have exactly 3 characters
        XCTAssertTrue(allCurrencies.allSatisfy { $0.alpha2Code == $0.alpha2Code.uppercased() && $0.alpha2Code.count == 3 })
    }
}
