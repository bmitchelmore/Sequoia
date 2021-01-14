//
//  String+Random.swift
//  SequoiaTests
//
//  Created by Blair Mitchelmore on 2021-01-14.
//

import Foundation

extension String {
    static func random(range: Range<Int> = 5..<25) -> String {
        let size = Int.random(in: range)
        var data = Data(capacity: size)
        for _ in 0..<size {
            data.append(UInt8.random(in: 65..<91))
        }
        return String(data: data, encoding: .utf8)!
    }
}
