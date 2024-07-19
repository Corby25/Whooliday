//
//  UtilityTest.swift
//  WhoolidayTests
//
//  Created by Fabio Tagliani on 15/07/24.
//

import XCTest
@testable import Whooliday

class UtilitiesTests: XCTestCase {

    var utilities: Utilities!

    override func setUp() {
        super.setUp()
        utilities = Utilities.shared
    }

    override func tearDown() {
        utilities = nil
        super.tearDown()
    }

    func testSharedInstance() {
        XCTAssertNotNil(Utilities.shared)
        XCTAssert(Utilities.shared === Utilities.shared)
    }

    @MainActor
    func testTopViewControllerWithNavigationController() {
        let rootVC = UIViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        let secondVC = UIViewController()
        navController.pushViewController(secondVC, animated: false)

        let topVC = utilities.topViewController(controller: navController)
        XCTAssertEqual(topVC, secondVC)
    }

    @MainActor
    func testTopViewControllerWithTabBarController() {
        let tabBarController = UITabBarController()
        let firstVC = UIViewController()
        let secondVC = UIViewController()
        tabBarController.viewControllers = [firstVC, secondVC]
        tabBarController.selectedIndex = 1

        let topVC = utilities.topViewController(controller: tabBarController)
        XCTAssertEqual(topVC, secondVC)
    }

  

    @MainActor
    func testTopViewControllerWithSimpleViewController() {
        let simpleVC = UIViewController()

        let topVC = utilities.topViewController(controller: simpleVC)
        XCTAssertEqual(topVC, simpleVC)
    }
}
