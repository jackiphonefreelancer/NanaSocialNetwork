//
//  NanaSocialNetworkTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/20/21.
//

import XCTest
@testable import NanaSocialNetwork

class LoginTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    override func setUp() {
        super.setUp()
    }
}

//MARK: - Test: Email validation
extension LoginTests {
    func testEmailIsValid() throws {
        let viewModel = LoginViewModel()
        XCTAssertTrue(viewModel.isValidEmail(email: "test@gmail.com"))
    }
    
    func testEmailIsNotValid() throws {
        let viewModel = LoginViewModel()
        XCTAssertFalse(viewModel.isValidEmail(email: "test@gmail"))
        XCTAssertFalse(viewModel.isValidEmail(email: "testgmail.com"))
    }
}

//MARK: - Test: Login
extension LoginTests {
    func testLoginSuccess() throws {
        let expectation = self.expectation(description: "LoginTests_Login")
        var result = false

        APIManager.shared.login(withEmail: "test1@nana.com", password: "123456", completion: { (success, error) in
            result = success
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertTrue(result)
    }
    
    func testLoginFail() throws {
        let expectation = self.expectation(description: "LoginTests_Login")
        var result = false

        APIManager.shared.login(withEmail: "test1@nana.com", password: "12345", completion: { (success, error) in
            result = success
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertFalse(result)
    }
}
