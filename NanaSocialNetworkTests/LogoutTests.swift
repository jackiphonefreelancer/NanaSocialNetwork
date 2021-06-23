//
//  LogoutTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/23/21.
//

import XCTest
import RxSwift
@testable import NanaSocialNetwork

class LogoutTests: XCTestCase {
    
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

//MARK: - Test: Logout
extension LogoutTests {
    func testLogout() throws {
        let expectation = self.expectation(description: "LogoutTests")
        var result = false
        
        let viewModel = ProfileViewModel()
        viewModel.logoutState
            .subscribe { state in
                result = state.element ?? false
                expectation.fulfill()
            }
            .disposed(by: disposeBag)
        viewModel.logout()
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertTrue(result)
    }
}
