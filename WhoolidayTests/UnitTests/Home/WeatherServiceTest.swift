//
//  WeatherServiceTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 09/07/24.
//

import XCTest
@testable import Whooliday

class WeatherServiceTests: XCTestCase {

    var weatherService: WeatherService!

    override func setUp() {
        super.setUp()
        weatherService = WeatherService()
    }

    override func tearDown() {
        weatherService = nil
        super.tearDown()
    }

    func testFetchWeatherData() async throws {
        // fetchWeatherData test
        let latitude = 41.8967
        let longitude = 12.4822
        
        let response = try await weatherService.fetchWeatherData(latitude: latitude, longitude: longitude)
        
        XCTAssertNotNil(response)
        XCTAssertFalse(response.error ?? false)
        XCTAssertNil(response.reason)
       
    }

    func testCalculateMonthlyAverages() {
        // calculateMonthlyAverages test
        let mockResponse = WeatherResponse(
            latitude: 45.4642,
            longitude: 9.1900,
            generationtime_ms: 0.1,
            utc_offset_seconds: 3600,
            timezone: "Europe/Rome",
            timezone_abbreviation: "CET",
            elevation: 122.0,
            daily_units: DailyUnits(time: "iso8601", temperature_2m_mean: "°C"),
            daily: DailyData(
                time: ["2023-01-01", "2023-01-02", "2023-02-01", "2023-02-02"],
                temperature_2m_mean: [10.0, 12.0, 8.0, 9.0]
            ),
            error: nil,
            reason: nil
        )
        
        let monthlyAverages = weatherService.calculateMonthlyAverages(from: mockResponse)
        
        XCTAssertEqual(monthlyAverages.count, 2)
        XCTAssertEqual(monthlyAverages[0].month, 1)
        XCTAssertEqual(monthlyAverages[0].temperature, 11.0, accuracy: 0.001)
        XCTAssertEqual(monthlyAverages[1].month, 2)
        XCTAssertEqual(monthlyAverages[1].temperature, 8.5, accuracy: 0.001)
    }

    func testMonthlyTemperatureExtensions() {
        let monthlyTemperatures = [
            MonthlyTemperature(month: 1, temperature: 10.0),
            MonthlyTemperature(month: 2, temperature: 12.0),
            MonthlyTemperature(month: 3, temperature: 15.0)
        ]
        
        XCTAssertEqual(monthlyTemperatures.averageTemperature(), 12.333, accuracy: 0.001)
        XCTAssertEqual(monthlyTemperatures.hottestMonth()?.month, 3)
        XCTAssertEqual(monthlyTemperatures.coldestMonth()?.month, 1)
    }
}
