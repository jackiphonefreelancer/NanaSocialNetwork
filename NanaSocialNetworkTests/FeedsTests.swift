//
//  ApiTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/22/21.
//

import XCTest
@testable import NanaSocialNetwork

class FeedsTests: XCTestCase {

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

//MARK: - Test: Fetch Feeds
extension FeedsTests {
    func testFetchFeeds() throws {
        let expectation = self.expectation(description: "FeedsTests")
        var result: [FeedItem]?
        
        APIManager.shared.fetchFeedList(completion: { (items, err) in
            result = items
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 10) // Timeout for 10 sec.
        XCTAssertNotNil(result)
    }
}

//MARK: - Test: Time ago display
extension FeedsTests {
    func testJustNow() throws {
        let date = Date(timeIntervalSinceNow: 0)
        XCTAssertEqual(date.timeAgoDisplay(), "just now")
    }
    
    func testSecondsAgo() throws {
        let date = Date(timeIntervalSinceNow: -30)
        XCTAssertEqual(date.timeAgoDisplay(), "30 seconds ago")
    }
    
    func testOneMinuteAgo() throws {
        let date = Date(timeIntervalSinceNow: -1 * TimeInterval.minute)
        XCTAssertEqual(date.timeAgoDisplay(), "1 minute ago")
    }
    
    func testMinutesAgo() throws {
        let date = Date(timeIntervalSinceNow: -28.0 * TimeInterval.minute)
        XCTAssertEqual(date.timeAgoDisplay(), "28 minutes ago")
    }
    
    func testOneHourAgo() throws {
        let date = Date(timeIntervalSinceNow: -1 * TimeInterval.hour)
        XCTAssertEqual(date.timeAgoDisplay(), "1 hour ago")
    }
    
    func testHoursAgo() throws {
        let date = Date(timeIntervalSinceNow: -12 * TimeInterval.hour)
        XCTAssertEqual(date.timeAgoDisplay(), "12 hours ago")
    }
    
    func testOneDayAgo() throws {
        let date = Date(timeIntervalSinceNow: -1 * TimeInterval.day)
        XCTAssertEqual(date.timeAgoDisplay(), "1 day ago")
    }
    
    func testDaysAgo() throws {
        let date = Date(timeIntervalSinceNow: -2 * TimeInterval.day)
        XCTAssertEqual(date.timeAgoDisplay(), "2 days ago")
    }
}
