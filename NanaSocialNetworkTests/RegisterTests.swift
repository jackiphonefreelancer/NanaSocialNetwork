//
//  RegisterTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/21/21.
//

import XCTest
import RxSwift
@testable import NanaSocialNetwork

class RegisterTests: XCTestCase {
    
    private let disposeBag = DisposeBag()

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
        var emailAlreadyInUse = false
        
        // Try to register with existing account
        let viewModel = RegisterViewModel(email: "test1@nana.com", password: "123456", displayname: "Test")
        viewModel.state
            .subscribe { state in
                switch (state.element) {
                case .success:
                    expectation.fulfill()
                case .error(let error):
                    emailAlreadyInUse = (error == .emailAlreadyInUse)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        viewModel.createUser()
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertTrue(emailAlreadyInUse)
    }
    
    func testRegisterWithWeakPassword() throws {
        let expectation = self.expectation(description: "RegisterTests")
        var weakPassword = false
        
        // Try to register with weak password
        let viewModel = RegisterViewModel(email: "test123456@abc.com", password: "123", displayname: "Test")
        viewModel.state
            .subscribe { state in
                switch (state.element) {
                case .success:
                    expectation.fulfill()
                case .error(let error):
                    weakPassword = (error == .weakPassword)
                    expectation.fulfill()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        viewModel.createUser()
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertTrue(weakPassword)
    }
}
