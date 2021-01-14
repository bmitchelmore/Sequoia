//
//  Array+Random.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation

extension Array {
    static func random(size: Int = 5, _ gen: @autoclosure () -> Element) -> [Element] {
        var array: [Element] = []
        for _ in 0..<size {
            array.append(gen())
        }
        return array
    }
}
