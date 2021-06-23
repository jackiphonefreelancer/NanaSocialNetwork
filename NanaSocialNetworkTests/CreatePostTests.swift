//
//  CreatePostTests.swift
//  NanaSocialNetworkTests
//
//  Created by Teerapat on 6/23/21.
//

import XCTest
import RxSwift
@testable import NanaSocialNetwork

class CreatePostTests: XCTestCase {
    
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

//MARK: - Test: Create Post
extension CreatePostTests {
    func testCanPost() throws {
        var canPost = false
        
        let viewModel = CreatePostViewModel()
        viewModel.postButtonState
            .subscribe { state in
                canPost = state.element ?? false
            }
            .disposed(by: disposeBag)
        
        /* Case 1: Both content and image are nil
           Expected: CanPost = false */
        viewModel.updateContentText(nil)
        viewModel.updateContentImage(nil)
        XCTAssertFalse(canPost)
        
        /* Case 2: Content is not nil but image is nil
           Expected: CanPost = true */
        viewModel.updateContentText("test")
        viewModel.updateContentImage(nil)
        XCTAssertTrue(canPost)
        
        /* Case 3: Content is nil but image is not nil
           Expected: CanPost = false */
        viewModel.updateContentText(nil)
        viewModel.updateContentImage(UIImage(named: "test_image"))
        XCTAssertFalse(canPost)
        
        /* Case 4: Both content and image are not nil
           Expected: CanPost = true */
        viewModel.updateContentText("Test")
        viewModel.updateContentImage(UIImage(named: "test_image"))
        XCTAssertTrue(canPost)
    }
    
    func testCreatePostWithoutImage() {
        let loginTests = LoginTests()
        do {
            // #1: Need to Login first
            try loginTests.testLoginSuccess()
            
            // #2 Create Post
            let expectation = self.expectation(description: "CreatePostTests")
            var success = false
            
            let viewModel = CreatePostViewModel(content: "Test Post", image: nil)
            viewModel.state
                .subscribe { state in
                    switch (state.element) {
                    case .success:
                        success = true
                        expectation.fulfill()
                    case .error:
                        success = false
                        expectation.fulfill()
                    default:
                        break
                    }
                }
                .disposed(by: disposeBag)
            viewModel.createPost()
            
            waitForExpectations(timeout: 10) // Timeout for 10 sec.
            XCTAssertTrue(success)
        } catch {
            
        }
    }
    
    func testCreatePostWithImage() {
        let loginTests = LoginTests()
        do {
            // #1: Need to Login first
            try loginTests.testLoginSuccess()
            
            // #2 Create Post
            let expectation = self.expectation(description: "CreatePostTests")
            var success = false
            
            let viewModel = CreatePostViewModel(content: "Test Post with Image", image: UIImage(named: "test_image"))
            viewModel.state
                .subscribe { state in
                    switch (state.element) {
                    case .success:
                        success = true
                        expectation.fulfill()
                    case .error:
                        success = false
                        expectation.fulfill()
                    default:
                        break
                    }
                }
                .disposed(by: disposeBag)
            viewModel.createPost()
            
            waitForExpectations(timeout: 15) // Timeout for 15 sec.
            XCTAssertTrue(success)
        } catch {
            XCTFail()
        }
    }
}
