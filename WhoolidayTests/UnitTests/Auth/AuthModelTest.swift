//
//  AuthModelTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 10/07/24.
//
import XCTest
@testable import Whooliday

@MainActor
class AuthModelTests: XCTestCase {
    
    var authModel: AuthModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        authModel = AuthModel()
    }
    
    override func tearDownWithError() throws {
        authModel = nil
        try super.tearDownWithError()
    }
    
    func testSignIn() async throws {
        do {
            try await authModel.signIn(withEmail: "fab@gmail.com", password: "bietto")
            XCTAssertNotNil(authModel.userSession)
            XCTAssertNotNil(authModel.currentUser)
        } catch {
            XCTFail("Sign in should not throw an error: \(error)")
        }
    }
    
    func testSignUp() async throws {
        do {
            try await authModel.signUp(withEmail: "new15@example.com", password: "newpassword", name: "New User", country: nil, currency: nil)
            XCTAssertNotNil(authModel.userSession)
            XCTAssertNotNil(authModel.currentUser)
            XCTAssertEqual(authModel.currentUser?.name, "New User")
        } catch {
            XCTFail("Sign up should not throw an error: \(error)")
        }
    }
    
    func testSignOut() throws {
        authModel.signOut()
        XCTAssertNil(authModel.userSession)
        XCTAssertNil(authModel.currentUser)
    }
    
    func testResetPassword() async throws {
        do {
            try await authModel.resetPassword(email: "test@example.com")
            // Se il reset della password ha successo, non dovrebbe lanciare un errore
        } catch {
            XCTFail("Reset password should not throw an error: \(error)")
        }
    }
    
    func testFetchUser() async throws {
        // Assumiamo che l'utente sia già autenticato
        await authModel.fetchUser()
        XCTAssertNotNil(authModel.currentUser)
        
    }
}
