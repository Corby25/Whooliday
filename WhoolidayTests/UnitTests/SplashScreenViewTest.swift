//
//  SplashScreenViewTest.swift
//  WhoolidayUITests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
@testable import Whooliday
import SwiftUI

class SplashScreenViewTests: XCTestCase {

    func testSplashScreenTimerAndTransition() {
        // Arrange
        let view = SplashScreenView()
        
        // Act
        view.startTypingAnimation()
        
        // Assert initial state
        XCTAssertFalse(view.navigateToContentView)
        
        // Simulate passage of time
        let expectation = XCTestExpectation(description: "Wait for timer")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.1) { // 2.1 seconds > 40 * 0.05
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
        
        // Assert final state
        XCTAssertTrue(view.navigateToContentView)
    }
    
    func testRiveAnimationPlayOnAppear() {
        // Arrange
        let view = SplashScreenView()
        
        // Act
        let _ = view.body
        
        // Assert
        XCTAssertTrue(view.textAnimationIntro.isPlaying)
    }
}
