//
//  ProfileViewUITest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class ProfileViewUITest: XCTestCase {

    
    func testLaunchPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Profile"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["listing-4"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"listing-4\"]",".buttons[\"listing-4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Choose Avatar"]/*@START_MENU_TOKEN@*/.buttons["Cancel"]/*[[".otherElements[\"Cancel\"].buttons[\"Cancel\"]",".buttons[\"Cancel\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Country"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Country\"]",".buttons[\"Country\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let doneButton = app.buttons["Done"]
        doneButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Currency"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Currency\"]",".buttons[\"Currency\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        doneButton.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Notifications"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Notifications\"]",".buttons[\"Notifications\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let doneButton2 = app.navigationBars["notification_settings"]/*@START_MENU_TOKEN@*/.buttons["Done"]/*[[".otherElements[\"Done\"].buttons[\"Done\"]",".buttons[\"Done\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        doneButton2.tap()
                                
    }
}
