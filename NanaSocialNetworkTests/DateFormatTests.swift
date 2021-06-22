//
//  DateFormatTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/22/21.
//

import XCTest
@testable import NanaSocialNetwork

class DateFormatTests: XCTestCase {

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

//MARK: - Test: Time ago
extension DateFormatTests {
    func testSecondsAgo() throws {
        let date = Date(timeIntervalSinceNow: -30)
        XCTAssertEqual(date.timeAgoDisplay(), "30 seconds ago")
    }
    
    func testMinutesAgo() throws {
        let date = Date(timeIntervalSinceNow: -28.0 * TimeInterval.minute)
        XCTAssertEqual(date.timeAgoDisplay(), "28 minutes ago")
    }
    
    func testHoursAgo() throws {
        let date = Date(timeIntervalSinceNow: -12 * TimeInterval.hour)
        XCTAssertEqual(date.timeAgoDisplay(), "12 hours ago")
    }
    
    func testDaysAgo() throws {
        let date = Date(timeIntervalSinceNow: -2 * TimeInterval.day)
        XCTAssertEqual(date.timeAgoDisplay(), "2 days ago")
    }
}
