//
//  ProfileModelTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//

import XCTest
import Combine
@testable import Whooliday

// Mock class for Firestore
class MockFirestoreProfile {
    static let shared = MockFirestoreProfile()
    
    private var data: [String: Any] = [
        "locale": "US",
        "currency": "USD",
        "sendEmail": true,
        "localNotifications": true
    ]
    
    func updateData(_ data: [String: Any], completion: ((Error?) -> Void)? = nil) {
        for (key, value) in data {
            self.data[key] = value
        }
        completion?(nil)
    }
    
    func addSnapshotListener(_ listener: @escaping ([String: Any]?, Error?) -> Void) -> MockListenerRegistrationProfile {
        listener(data, nil)
        return MockListenerRegistrationProfile()
    }
}

// Mock class for ListenerRegistration
class MockListenerRegistrationProfile {
    func remove() {
        // No-op for mock
    }
}

class ProfileViewModelProfileTests: XCTestCase {
    var viewModel: ProfileViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
          super.setUp()
          viewModel = ProfileViewModel()
          cancellables = []
      }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testInitialValues() {
        XCTAssertEqual(viewModel.selectedCountry, "Select Country")
        XCTAssertEqual(viewModel.selectedCurrency, "Select Currency")
        XCTAssertFalse(viewModel.sendEmail)
        XCTAssertFalse(viewModel.localNotifications)
    }
    
    func testSetSelectedCountry() {
        let expectation = self.expectation(description: "Locale update")
        
        viewModel.setUser(userID: "testUser")
        viewModel.selectedCountry = "Canada"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.selectedCountry, "Canada")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testSetSelectedCurrency() {
        let expectation = self.expectation(description: "Currency update")
        
        viewModel.setUser(userID: "testUser")
        viewModel.selectedCurrency = "CAD"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertEqual(self.viewModel.selectedCurrency, "CAD")
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testToggleSendEmail() {
        let expectation = self.expectation(description: "Send email update")
        
        viewModel.setUser(userID: "testUser")
        viewModel.sendEmail = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.sendEmail)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testToggleLocalNotifications() {
        let expectation = self.expectation(description: "Local notifications update")
        
        viewModel.setUser(userID: "testUser")
        viewModel.localNotifications = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            XCTAssertTrue(self.viewModel.localNotifications)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
    
    func testFetchUserSettings() {
        let expectation = self.expectation(description: "Fetch user settings")
        
        viewModel.setUser(userID: "testUser")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            print(self.viewModel.selectedCountry);
            
            // It should show not permissions
            XCTAssertEqual(self.viewModel.selectedCountry, "Select Country")
            XCTAssertEqual(self.viewModel.selectedCurrency, "Select Currency")
            XCTAssertTrue(!self.viewModel.sendEmail)
            XCTAssertTrue(!self.viewModel.localNotifications)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2.0, handler: nil)
    }
}
