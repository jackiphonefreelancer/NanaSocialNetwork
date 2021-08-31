//
//  NanaSocialNetworkTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/20/21.
//

import XCTest
import RxSwift
@testable import NanaSocialNetwork

class LoginTests: XCTestCase {
    
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

//MARK: - Test: Email validation
extension LoginTests {
    func testEmailIsValid() throws {
        let viewModel = LoginViewModel(email: "test@gmail.com", password: nil)
        XCTAssertTrue(viewModel.isValidEmail())
    }
    
    func testEmailIsNotValid() throws {
        let viewModel = LoginViewModel(email: "test@gmail", password: nil)
        XCTAssertFalse(viewModel.isValidEmail())
        
        viewModel.updateEmail("testgmail.com")
        XCTAssertFalse(viewModel.isValidEmail())
    }
}

//MARK: - Test: Login
extension LoginTests {
    func testLoginSuccess() throws {
        let expectation = self.expectation(description: "LoginTests")
        var result = false
        
        // Login with existing account and correct password
        let viewModel = LoginViewModel(email: "test1@nana.com", password: "123456")
        viewModel.state
            .subscribe { state in
                switch (state.element) {
                case .success:
                    result = true
                    expectation.fulfill()
                case .error(_):
                    result = false
                    expectation.fulfill()
                default:
                    break
                }
            }
            .disposed(by: disposeBag)
        viewModel.login()
        
        waitForExpectations(timeout: 15) // Timeout for 15 sec.
        XCTAssertTrue(result)
    }
    
    func testLoginFailWithWrongPassword() throws {
        let expectation = self.expectation(description: "LoginTests")
        var wrongPassword = false
        
        // Login with existing account and incorrect password
        let viewModel = LoginViewModel(email: "test1@nana.com", password: "12345")
        viewModel.state
            .subscribe { state in
                switch (state.element) {
                case .success:
                    wrongPassword = false
                    expectation.fulfill()
                case .error(let error):
                    wrongPassword = (error == .wrongPassword)
                    expectation.fulfill()
                default:
                    wrongPassword = false
                }
            }
            .disposed(by: disposeBag)
        viewModel.login()
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertTrue(wrongPassword)
    }
}

//MARK: - Test: Fetch App User
extension LoginTests {
    func testFetchUser() throws {
        let expectation = self.expectation(description: "LoginTests")
        let uid = "IEvxnCWbZRMYe02LPQKl1ahB9012" // Test user id
        var appUser: AppUser?
        
        APIManager.shared.fetchUserInfo(uid: uid, completion: { (user, err) in
            appUser = user
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertNotNil(appUser)
    }
}
