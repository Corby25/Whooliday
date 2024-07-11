//
//  testRec.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class SearchInputSearchUITest: XCTestCase {


    func testLaunchPerformance() {
        
        let app = XCUIApplication()
        app.launch()
        sleep(4)
        XCUIApplication().staticTexts["Everywhere - Always - Guests"].tap()
        
     
                        
        sleep(4)

        

        let destinationsearchviewScrollView = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let elementsQuery = destinationsearchviewScrollView.otherElements
       
        elementsQuery.staticTexts["Seleziona le date"].tap()
        elementsQuery.staticTexts["26"].tap()
        elementsQuery.staticTexts["28"].tap()
        elementsQuery.staticTexts["2 adulti"].tap()
        destinationsearchviewScrollView.otherElements.containing(.button, identifier:"Close").children(matching: .button).matching(identifier: "Add").element(boundBy: 1).tap()
        
        
        let closeElementsQuery = app/*@START_MENU_TOKEN@*/.scrollViews["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"].scrollViews[\"DestinationSearchView\"]",".scrollViews[\"DestinationSearchView\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.otherElements.containing(.button, identifier:"Close")
        let removeButton = closeElementsQuery.children(matching: .button).matching(identifier: "Remove").element(boundBy: 0)
        removeButton.tap()
        removeButton.tap()
        
        let addButton = closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 0)
        addButton.tap()
        addButton.tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Add").element(boundBy: 1).tap()
        closeElementsQuery.children(matching: .button).matching(identifier: "Remove").element(boundBy: 1).tap()
        removeButton.tap()
        
        
        app/*@START_MENU_TOKEN@*/.buttons["DestinationSearchView"]/*[[".otherElements[\"SplashScreenView\"]",".buttons[\"Search\"]",".buttons[\"DestinationSearchView\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
           
    }
    
   
}
