//
//  ListingItemViewUITest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class ListingItemViewUITest: XCTestCase {


    func testSearchAndListingAppears() throws {
        
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
        
        let elementsQuery1 = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
        elementsQuery1.staticTexts["Seleziona le date"].tap()
        elementsQuery1.staticTexts["19"].tap()
        elementsQuery1.staticTexts["26"].tap()
        
        
        let destinationsearchviewScrollView = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        destinationsearchviewScrollView.otherElements.staticTexts["Who"].tap()
        
        let closeElementsQuery = destinationsearchviewScrollView.otherElements.containing(.button, identifier:"Close")
        closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 1).tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Remove").element(boundBy: 1).tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 0).tap()
        app/*@START_MENU_TOKEN@*/.buttons["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"]",".buttons[\"Search\"]",".buttons[\"DestinationSearchView\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(60)
        
        
        let elementsQuery = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"SplashScreenView\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
       
        
        app/*@START_MENU_TOKEN@*/.buttons["Arrow Up Circle"]/*[[".otherElements[\"SplashScreenView\"]",".segmentedControls.buttons[\"Arrow Up Circle\"]",".buttons[\"Arrow Up Circle\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Favorite"]/*[[".otherElements[\"SplashScreenView\"]",".segmentedControls.buttons[\"Favorite\"]",".buttons[\"Favorite\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.buttons["Sort"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Arrow Down Circle"]/*[[".otherElements[\"SplashScreenView\"]",".segmentedControls.buttons[\"Arrow Down Circle\"]",".buttons[\"Arrow Down Circle\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCUIApplication()/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"SplashScreenView\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.buttons["Milano -  Italy, UNAHOTELS Cusani Milano, 4.616€, 8.1"].tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Love"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Love\"]",".buttons[\"Love\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Back"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Back\"]",".buttons[\"Back\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["line.3.horizontal.decrease"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"line.3.horizontal.decrease\"]",".buttons[\"line.3.horizontal.decrease\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let elementsQuery3 = app/*@START_MENU_TOKEN@*/.scrollViews/*[[".otherElements[\"SplashScreenView\"].scrollViews",".scrollViews"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements
        elementsQuery3.buttons["General"].images["Go Down"].tap()
        elementsQuery3.buttons["Free parking"].tap()
        elementsQuery3.buttons["Free WiFi"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Apply Filters"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Apply Filters\"]",".buttons[\"Apply Filters\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(60)
        app.otherElements["SplashScreenView"].children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .button)["Love"].tap()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["sun.horizon"]/*[[".otherElements[\"SplashScreenView\"].scrollViews.otherElements",".buttons[\"Resort\"].images[\"sun.horizon\"]",".images[\"sun.horizon\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.swipeLeft()
        app/*@START_MENU_TOKEN@*/.scrollViews.otherElements.images["cup.and.saucer"]/*[[".otherElements[\"SplashScreenView\"].scrollViews.otherElements",".buttons[\"B&B\"].images[\"cup.and.saucer\"]",".images[\"cup.and.saucer\"]",".scrollViews.otherElements"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        sleep(60)

    }
}
