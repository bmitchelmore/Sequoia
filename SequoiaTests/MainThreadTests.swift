//
//  MainThreadTests.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import XCTest
@testable import Sequoia

class MainThreadTests: XCTestCase {
    func testFromMainThread() throws {
        let wait = expectation(description: "Finished")
        
        let mainThread = GCDMainThreadDispatch()
        mainThread.call {
            XCTAssertTrue(Thread.isMainThread)
            wait.fulfill()
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }

    func testFromBackgroundThread() throws {
        let wait = expectation(description: "Finished")
        
        let mainThread = GCDMainThreadDispatch()
        DispatchQueue.global(qos: .background).async {
            XCTAssertFalse(Thread.isMainThread)
            mainThread.call {
                XCTAssertTrue(Thread.isMainThread)
                wait.fulfill()
            }
        }
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testSuccessHelper() throws {
        let wait = expectation(description: "Finished")
        
        let completion: (Result<Int, Error>) -> Void = { _ in
            XCTAssertTrue(Thread.isMainThread)
            wait.fulfill()
        }
        let mainThread = GCDMainThreadDispatch()
        mainThread.success(value: 5, completion: completion)
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
    
    func testFailureHelper() throws {
        let wait = expectation(description: "Finished")
        
        let completion: (Result<Int, Error>) -> Void = { _ in
            XCTAssertTrue(Thread.isMainThread)
            wait.fulfill()
        }
        let mainThread = GCDMainThreadDispatch()
        mainThread.failure(error: NSError(), completion: completion)
        
        waitForExpectations(timeout: 0.5, handler: nil)
    }
}
