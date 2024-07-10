//
//  HomeViewUITest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
@testable import Whooliday

final class HomeViewUITests: XCTestCase {
    
    let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }
    
    func testHeaderViewExists() throws {
        sleep(4)
        let headerTitle = app.staticTexts["Search your hotel"]
        let subTitle = app.staticTexts["Start here"]
        
        XCTAssertTrue(headerTitle.exists, "Header title should exist")
        XCTAssertTrue(subTitle.exists, "Subtitle should exist")
    }
    
    func testContinentButtonsExist() throws {
        sleep(4)
        let continents = ["World", "Europe", "Asia", "Africa", "Americas", "Oceania", "Antarctica"]
        
        for continent in continents {
            let button = app.buttons[continent]
            XCTAssertTrue(button.exists, "\(continent) button should exist")
        }
    }
    
    func testSearchBarExists() throws {
        // Wait for the app to settle
        sleep(4)
        
        // Print view hierarchy
        print("View hierarchy:")
        print(app.debugDescription)
        
        // Check for any unexpected alerts
        XCTAssertFalse(app.alerts.element.exists, "Unexpected alert appeared")
        
        // Look for the search bar using multiple methods
        let searchBar1 = app.otherElements["SearchAndFilterBar"]
        let searchBar2 = app.descendants(matching: .any)["SearchAndFilterBar"]
        let searchBarPredicate = NSPredicate(format: "label CONTAINS[c] %@", "Search")
        let searchBar3 = app.descendants(matching: .any).matching(searchBarPredicate).firstMatch
        
        // Print existence of each search bar query
        print("searchBar1 exists: \(searchBar1.exists)")
        print("searchBar2 exists: \(searchBar2.exists)")
        
        // Assert with a wait
        XCTAssertTrue(searchBar2.waitForExistence(timeout: 5), "Search bar should exist within 5 seconds")
        
        // If the assertion fails, print more details
        if !searchBar2.exists {
            print("Search bar not found. Here are some details:")
            print("Number of otherElements: \(app.otherElements.count)")
            print("Identifiers of otherElements: \(app.otherElements.allElementsBoundByIndex.map { $0.identifier })")
        }
    }
    
    func testCardViewInteraction() throws {
        // Wait for the app to settle
        sleep(4)
        
        // Print initial view hierarchy
        print("Initial view hierarchy:")
        print(app.debugDescription)
        
        // Look for the first CardViewBig
        let firstCard = app.descendants(matching: .any)["CardViewBig"].firstMatch
        XCTAssertTrue(firstCard.waitForExistence(timeout: 5), "First big card should exist within 5 seconds")
        
        // If it exists, try to tap it
        if firstCard.exists {
            firstCard.tap()
            print("Card tapped")
            
            // Wait a moment for the view to update
            sleep(2)
            
            // Print view hierarchy after tap
            print("View hierarchy after tap:")
            print(app.debugDescription)
            
            // Check for any unexpected alerts
            XCTAssertFalse(app.alerts.element.exists, "Unexpected alert appeared")
            
            // Look for CityDetailView
            let cityDetailView = app.descendants(matching: .any).matching(identifier: "CityDetailView").firstMatch
            XCTAssertTrue(cityDetailView.waitForExistence(timeout: 10), "City detail view should appear within 10 seconds after tapping a card")
            
            // If CityDetailView is not found, check for specific elements that should be in it
            if !cityDetailView.exists {
                // Replace these with actual elements you expect to see in CityDetailView
                let expectedElement = app.staticTexts["City Name"]
                XCTAssertTrue(expectedElement.exists, "Expected element in CityDetailView not found")
            }
        }
    }
    
    func testContinentSelection() throws {
        sleep(4)
        let europeButton = app.buttons["Europe"]
        XCTAssertTrue(europeButton.exists, "Europe button should exist")
        
        europeButton.tap()
        
        // You might want to add a way to verify that the places have been updated
        // This could involve checking for specific place names or counting the number of cards
    }
}
