//
//  MockImages.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation
import XCTest
@testable import Sequoia

final class MockImages: ImageCache {
    var results: [URL:Result<UIImage, Error>] = [:]
    
    func load(url: URL) -> UIImage? {
        try? results[url]?.get()
    }
    
    func download(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        results[url].map { completion($0) }
    }
}
