//
//  SignInViewUITest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 11/07/24.
//

import XCTest

final class SignInViewUITest: XCTestCase {


    func testSignIn() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(4)
        
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Profile"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Logout"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Logout\"]",".buttons[\"Logout\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Login"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["_TtGC7SwiftUI19UIHosting"]/*[[".otherElements[\"SplashScreenView\"].navigationBars[\"_TtGC7SwiftUI19UIHosting\"]",".navigationBars[\"_TtGC7SwiftUI19UIHosting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Forgot Password?"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Forgot Password?\"]",".buttons[\"Forgot Password?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let okButton = app.alerts["Error"].scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".otherElements[\"SplashScreenView\"].textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".otherElements[\"SplashScreenView\"].textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("fab@gmail.com")
        
        let passwordSecureTextField = app/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".otherElements[\"SplashScreenView\"].secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("bietto")
        app/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
    }
    
    
    func testSignUp() throws {
        let app = XCUIApplication()
        app.launch()
        
        sleep(4)
    
        
        app.tabBars["Tab Bar"].buttons["Login"].tap()

        app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
       
        
        
        app.textFields["Name"].tap()
        app.textFields["Name"].typeText("ttest1")
        
        app.textFields["Email"].tap()
        app.textFields["Email"].typeText("ttest15@gmail.com")
        
        let passwordSecureTextField = app.secureTextFields["Password"]

        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("bietto")
        app.buttons["Sign Up"].tap()
        
        
        sleep(2)
        
        app.tabBars["Tab Bar"].buttons["Profile"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Logout"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Logout\"]",".buttons[\"Logout\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        
        app/*@START_MENU_TOKEN@*/.tabBars["Tab Bar"]/*[[".otherElements[\"SplashScreenView\"].tabBars[\"Tab Bar\"]",".tabBars[\"Tab Bar\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Login"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Sign Up"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Sign Up\"]",".buttons[\"Sign Up\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.navigationBars["_TtGC7SwiftUI19UIHosting"]/*[[".otherElements[\"SplashScreenView\"].navigationBars[\"_TtGC7SwiftUI19UIHosting\"]",".navigationBars[\"_TtGC7SwiftUI19UIHosting\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.buttons["Back"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Forgot Password?"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Forgot Password?\"]",".buttons[\"Forgot Password?\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let okButton = app.alerts["Error"].scrollViews.otherElements.buttons["OK"]
        okButton.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".otherElements[\"SplashScreenView\"].textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.textFields["Email"]/*[[".otherElements[\"SplashScreenView\"].textFields[\"Email\"]",".textFields[\"Email\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.typeText("fab@gmail.com")
        
        let passwordSecureTextField2 = app/*@START_MENU_TOKEN@*/.secureTextFields["Password"]/*[[".otherElements[\"SplashScreenView\"].secureTextFields[\"Password\"]",".secureTextFields[\"Password\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/

        passwordSecureTextField2.tap()
        passwordSecureTextField2.typeText("bietto")
        app/*@START_MENU_TOKEN@*/.buttons["Sign In"]/*[[".otherElements[\"SplashScreenView\"].buttons[\"Sign In\"]",".buttons[\"Sign In\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        sleep(2)
        
    }
}
