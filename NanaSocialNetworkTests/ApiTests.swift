//
//  ApiTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/22/21.
//

import XCTest
@testable import NanaSocialNetwork

class ApiTests: XCTestCase {

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

//MARK: - Test: Fetch User & Post
extension ApiTests {
    func testFetchUser() throws {
        let expectation = self.expectation(description: "ApiTests")
        let uid = "IEvxnCWbZRMYe02LPQKl1ahB9012" // Test user id
        var appUser: AppUser?
        
        APIManager.shared.fetchUserInfo(uid: uid, completion: { (user, err) in
            appUser = user
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertNotNil(appUser)
    }
    
    func testFetchFeeds() throws {
        let expectation = self.expectation(description: "ApiTests")
        var result: [FeedItem]?
        
        APIManager.shared.fetchFeedList(completion: { (items, err) in
            result = items
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertNotNil(result)
    }
}
