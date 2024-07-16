//
//  FavoritesUITest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest

final class FavoritesUITest: XCTestCase {

    func testFavorites() throws {
        let app = XCUIApplication()
        app.launch()
        
        
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Favorites"].tap()
        
        let unknownHotelCityFrom20240718A20240725GuestNumber3154300Button = app/*@START_MENU_TOKEN@*/.collectionViews["Sidebar"].buttons["Unknown Hotel, City, From: 2024-07-18, A: 2024-07-25, Guest Number: 3, €1.543,00"]/*[[".otherElements[\"SplashScreenView\"].collectionViews[\"Sidebar\"]",".cells.buttons[\"Unknown Hotel, City, From: 2024-07-18, A: 2024-07-25, Guest Number: 3, €1.543,00\"]",".buttons[\"Unknown Hotel, City, From: 2024-07-18, A: 2024-07-25, Guest Number: 3, €1.543,00\"]",".collectionViews[\"Sidebar\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/
        sleep(7)
        unknownHotelCityFrom20240718A20240725GuestNumber3154300Button.tap()
        
        let verticalScrollBar1PageCollectionView = app.scrollViews.otherElements.collectionViews.containing(.other, identifier:"Vertical scroll bar, 1 page").element
        app.buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Places"]/*[[".otherElements[\"SplashScreenView\"]",".segmentedControls.buttons[\"Places\"]",".buttons[\"Places\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.collectionViews["Sidebar"].buttons["1, From:, 2024-07-19, To:, 2024-07-26, Max price:, 300,00 EUR, Guest Number:, 2, Where:, Miami"]/*[[".otherElements[\"SplashScreenView\"].collectionViews[\"Sidebar\"]",".cells.buttons[\"1, From:, 2024-07-19, To:, 2024-07-26, Max price:, 300,00 EUR, Guest Number:, 2, Where:, Miami\"]",".buttons[\"1, From:, 2024-07-19, To:, 2024-07-26, Max price:, 300,00 EUR, Guest Number:, 2, Where:, Miami\"]",".collectionViews[\"Sidebar\"]"],[[[-1,3,1],[-1,0,1]],[[-1,2],[-1,1]]],[0,0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["_TtGC7SwiftUI19UIHosting"]/*[[".otherElements[\"SplashScreenView\"].navigationBars[\"_TtGC7SwiftUI19UIHosting\"]",".navigationBars[\"_TtGC7SwiftUI19UIHosting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Back"].tap()
                
     
                                
    }
}
