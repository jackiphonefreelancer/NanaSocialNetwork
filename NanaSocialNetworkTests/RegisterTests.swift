//
//  RegisterTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/21/21.
//

import XCTest
@testable import NanaSocialNetwork

class RegisterTests: XCTestCase {

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

//MARK: - Test: Register
extension RegisterTests {
    func testRegisterWithEmailAlreadyInUse() throws {
        let expectation = self.expectation(description: "RegisterTests")
        var error: CreateUserError?
        
        AuthenticationManager.shared.createUser(withEmail: "test1@nana.com", password: "123456", completion: { (result, err) in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        if let error = error {
            XCTAssertTrue(error == .emailAlreadyInUse)
        } else {
            XCTFail()
        }
    }
    
    func testRegisterWithWeakPassword() throws {
        let expectation = self.expectation(description: "RegisterTests")
        var error: CreateUserError?
        
        AuthenticationManager.shared.createUser(withEmail: "test12345@nana.com", password: "1111", completion: { (result, err) in
            error = err
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        if let error = error {
            XCTAssertTrue(error == .weakPassword)
        } else {
            XCTFail()
        }
    }
}
