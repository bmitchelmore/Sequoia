//
//  SearchPage.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

struct SearchPage<T> {
    var results: [T]
    var lastCursor: String?
}
