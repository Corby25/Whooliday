//
//  PriceChartViewTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 11/07/24.
//
import XCTest
@testable import Whooliday

class PriceChartViewTests: XCTestCase {
    
    var viewModel: ExploreViewModel!
    var mockService: MockExploreService!
    
    override func setUp() {
        super.setUp()
        mockService = MockExploreService()
        viewModel = ExploreViewModel(service: mockService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockService = nil
        super.tearDown()
    }
    
    func testInitialState() {
        XCTAssertTrue(viewModel.showDailyPrices)
        XCTAssertTrue(viewModel.dailyPrices.isEmpty)
        XCTAssertTrue(viewModel.weeklyAverages.isEmpty)
    }
    
    func testPopulatePriceCalendar() {
        let testData: [String: PriceData] = [
            "2024-06-24": PriceData(daily: 141.05),
            "2024-06-25": PriceData(daily: 142.00),
            "2024-06-26": PriceData(daily: 143.50)
        ]
        
        viewModel.priceCalendar = testData
        viewModel.dailyPrices = viewModel.priceCalendar.map { (formattedDate($0.key), $0.value.daily) }.sorted { $0.0 < $1.0 }
        
        XCTAssertEqual(viewModel.dailyPrices.count, 3)
        XCTAssertEqual(viewModel.dailyPrices[0].1, 141.05)
        XCTAssertEqual(viewModel.dailyPrices[1].1, 142.00)
        XCTAssertEqual(viewModel.dailyPrices[2].1, 143.50)
    }
    
    func testCalculateWeeklyAverages() {
        let testData: [String: PriceData] = [
            "2024-06-24": PriceData(daily: 140.00),
            "2024-06-25": PriceData(daily: 142.00),
            "2024-06-26": PriceData(daily: 144.00),
            "2024-06-27": PriceData(daily: 146.00),
            "2024-06-28": PriceData(daily: 148.00),
            "2024-06-29": PriceData(daily: 150.00),
            "2024-06-30": PriceData(daily: 152.00),
            "2024-07-1": PriceData(daily: 146.00),
            "2024-07-2": PriceData(daily: 148.00),
            "2024-07-3": PriceData(daily: 150.00),
            "2024-07-4": PriceData(daily: 152.00)
        ]
        
        viewModel.priceCalendar = testData
        viewModel.dailyPrices = viewModel.priceCalendar.map { (formattedDate($0.key), $0.value.daily) }.sorted { $0.0 < $1.0 }
        viewModel.calculateWeeklyAverages()
        
        // caluclate , update, delete...
        XCTAssertEqual(viewModel.weeklyAverages.count, 0)
    }
    
    func testToggleShowDailyPrices() {
        XCTAssertTrue(viewModel.showDailyPrices)
        
        viewModel.showDailyPrices = false
        XCTAssertFalse(viewModel.showDailyPrices)
        
        viewModel.showDailyPrices = true
        XCTAssertTrue(viewModel.showDailyPrices)
    }
}

// Helper function to match the one in the original code
private func formattedDate(_ dateString: String) -> String {
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat = "yyyy-MM-dd"
    
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat = "MMM d"
    
    if let date = inputFormatter.date(from: dateString) {
        return outputFormatter.string(from: date)
    }
    return dateString
}

// Mock service for testing
class MockExploreService: ExploreService {
    
}
