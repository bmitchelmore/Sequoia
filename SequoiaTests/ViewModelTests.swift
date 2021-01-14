//
//  ViewModelTests.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import XCTest
@testable import Sequoia

class ViewModelTests: XCTestCase {

    func testLoadOnStart() throws {
        let size = Int.random(in: 2..<6)
        let results = SearchPage(
            results: [RepoDetails].random(size: size, RepoDetails.random()),
            lastCursor: nil
        )
        let firstAvatar = UIImage()
        
        let search = MockSearch()
        search.expectSearch(result: .success(results))
        let images = MockImages()
        images.results[URL(string: results.results[0].owner.avatar!)!] = .success(firstAvatar)
        
        let model = RepoDetailsViewModel(search: search, images: images)
        
        // make sure the data matches what we set up
        XCTAssertEqual(model.cellCount, size)
        let cell = model.cell(forIndex: 0)
        XCTAssertEqual(cell.name, results.results.first?.name)
        XCTAssertTrue(cell.avatar === firstAvatar)
    }
    
    func testLoadMore() throws {
        let size = Int.random(in: 2..<6)
        let page1 = SearchPage(
            results: [RepoDetails].random(size: size, RepoDetails.random()),
            lastCursor: String.random()
        )
        let page2 = SearchPage(
            results: [RepoDetails].random(size: size, RepoDetails.random()),
            lastCursor: nil
        )
        
        let search = MockSearch()
        search.expectSearch(result: .success(page1))
        search.expectSearch(result: .success(page2))
        let images = MockImages()
        
        let model = RepoDetailsViewModel(search: search, images: images)
        
        XCTAssertEqual(model.cellCount, size)
        let cell1 = model.cell(forIndex: model.cellCount - 1)
        XCTAssertEqual(cell1.name, page1.results.last?.name)
        
        model.loadMore()
        
        // make sure the model data changed
        XCTAssertEqual(model.cellCount, size * 2)
        let cell2 = model.cell(forIndex: model.cellCount - 1)
        XCTAssertEqual(cell2.name, page2.results.last?.name)
    }
    
    func testLoadMoreWithNoCursor() throws {
        let size = Int.random(in: 2..<6)
        let results = SearchPage(
            results: [RepoDetails].random(size: size, RepoDetails.random()),
            lastCursor: nil
        )
        
        let search = MockSearch()
        search.expectSearch(result: .success(results))
        let images = MockImages()
        
        let model = RepoDetailsViewModel(search: search, images: images)
        
        XCTAssertEqual(model.cellCount, size)
        let cell1 = model.cell(forIndex: model.cellCount - 1)
        XCTAssertEqual(cell1.name, results.results.last?.name)
        
        model.loadMore()
        
        // make sure nothing changed
        XCTAssertEqual(model.cellCount, size)
        let cell2 = model.cell(forIndex: model.cellCount - 1)
        XCTAssertEqual(cell2.name, results.results.last?.name)
    }
    
    func testPreloadingImages() throws {
        let wait = expectation(description: "Finished")
        
        let size = Int.random(in: 2..<6)
        let results = SearchPage(
            results: [RepoDetails].random(size: size, RepoDetails.random()),
            lastCursor: nil
        )
        
        let search = MockSearch()
        search.expectSearch(result: .success(results))
        let images = MockImages()
        
        let model = RepoDetailsViewModel(search: search, images: images)
        
        XCTAssertEqual(model.cellCount, size)
        let cell = model.cell(forIndex: 0)
        XCTAssertEqual(cell.name, results.results.first?.name)
        XCTAssertNil(cell.avatar)
        
        let avatar = UIImage()
        images.results[URL(string: results.results[0].owner.avatar!)!] = .success(avatar)

        // this should be called after the image preload finishes
        model.onCellsUpdated = {
            // make sure the avatar got updated
            XCTAssertEqual(model.cellCount, size)
            let cell = model.cell(forIndex: 0)
            XCTAssertEqual(cell.name, results.results.first?.name)
            XCTAssertTrue(cell.avatar === avatar)
            wait.fulfill()
        }
        model.preloadImages(for: [0])
        model.loadMore()
        
        waitForExpectations(timeout: 0.25, handler: nil)
    }
}
