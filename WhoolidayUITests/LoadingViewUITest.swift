//
//  LoadingViewUItest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class LoadingViewUITest: XCTestCase {


    func testLoadingView() throws {
        
        let app = XCUIApplication()
        app.launch()
        
        sleep(4)
        app/*@START_MENU_TOKEN@*/.staticTexts["Everywhere - Always - Guests"]/*[[".otherElements[\"SplashScreenView\"].staticTexts[\"Everywhere - Always - Guests\"]",".staticTexts[\"Everywhere - Always - Guests\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        // Find the search TextField
                let searchField = app.textFields["searchDestinationTextField"]
                XCTAssert(searchField.waitForExistence(timeout: 5), "Search field did not appear")
                
                // Tap the search field and enter text
                searchField.tap()
                searchField.typeText("Milano")
                
        sleep(2)
        
        let milanoMetropolitanCityOfMilanItalyStaticText = app.scrollViews["DestinationSearchView"].otherElements.collectionViews.staticTexts["Milano, Metropolitan City of Milan, Italy"]
        milanoMetropolitanCityOfMilanItalyStaticText.tap()
        milanoMetropolitanCityOfMilanItalyStaticText.tap()
        
        let elementsQuery = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
        elementsQuery.staticTexts["Seleziona le date"].tap()
        elementsQuery.staticTexts["19"].tap()
        elementsQuery.staticTexts["26"].tap()
        
        
        let destinationsearchviewScrollView = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        destinationsearchviewScrollView.otherElements.staticTexts["Who"].tap()
        
        let closeElementsQuery = destinationsearchviewScrollView.otherElements.containing(.button, identifier:"Close")
        closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 1).tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Remove").element(boundBy: 1).tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.buttons["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"]",".buttons[\"Search\"]",".buttons[\"DestinationSearchView\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(10)
                        
     
        
        
        
    }
}
