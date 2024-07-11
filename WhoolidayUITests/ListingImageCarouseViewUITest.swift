//
//  testCarosel.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class ListingImageCarouseView: XCTestCase {


    func testCaroselWorking() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(5)
        
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Favorites"].tap()
        
        sleep(8)

        
        
        
    }
}
