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
        let currency = Currency(name: "Test Currency", code: "TST")
        XCTAssertEqual(currency.name, "Test Currency")
        XCTAssertEqual(currency.code, "TST")
    }

    func testCurrencyEquality() {
        let currency1 = Currency(name: "Test Currency", code: "TST")
        let currency2 = Currency(name: "Test Currency", code: "TST")
        let currency3 = Currency(name: "Another Currency", code: "ANC")

        XCTAssertEqual(currency1, currency2)
        XCTAssertNotEqual(currency1, currency3)
    }

    func testAllCurrencies() {
        let allCurrencies = Currency.allCurrencies



        // Test for the presence of some specific currencies
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "United States Dollar" && $0.code == "USD" }))
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "Euro" && $0.code == "EUR" }))
        XCTAssertTrue(allCurrencies.contains(where: { $0.name == "Japanese Yen" && $0.code == "JPY" }))

        // Test that all currency codes are unique
        let currencyCodes = allCurrencies.map { $0.code }
        XCTAssertEqual(currencyCodes.count, Set(currencyCodes).count)

        // Test that all currency names are unique
        let currencyNames = allCurrencies.map { $0.name }
        XCTAssertEqual(currencyNames.count, Set(currencyNames).count)

        // Test that all currency codes are uppercase and have exactly 3 characters
        XCTAssertTrue(allCurrencies.allSatisfy { $0.code == $0.code.uppercased() && $0.code.count == 3 })
    }
}
