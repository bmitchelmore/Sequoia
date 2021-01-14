//
//  MainThread.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation

protocol MainThreadDispatch {
    func call(fn: @escaping () -> Void)
}

final class GCDMainThreadDispatch: MainThreadDispatch {
    func call(fn: @escaping () -> Void) {
        DispatchQueue.main.async(execute: fn)
    }
}

extension MainThreadDispatch {
    func success<T>(value: T, completion: @escaping (Result<T,Error>) -> Void) {
        call { completion(.success(value)) }
    }
    func failure<T>(error: Error, completion: @escaping (Result<T,Error>) -> Void) {
        call { completion(.failure(error)) }
    }
}
