//
//  ImageCache.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation
import UIKit

enum ImageDownloadError: Error {
    case imageNotFound
    case invalidImageData
}

protocol ImageCache {
    func load(url: URL) -> UIImage?
    func download(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void)
}

final class SimpleImageCache: ImageCache {
    private let session: URLSession
    private let fs: FileManager
    private let mainThread: MainThreadDispatch
    private let root: URL
    
    init(session: URLSession = .shared, fs: FileManager = .default, mainThread: MainThreadDispatch = GCDMainThreadDispatch()) throws {
        self.session = session
        self.fs = fs
        self.mainThread = mainThread
        
        let dir = try fs.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("avatars")
        try fs.createDirectory(at: dir, withIntermediateDirectories: true, attributes: nil)
        self.root = dir
    }
    
    func load(url: URL) -> UIImage? {
        let dest = root.appendingPathComponent("\(url.hashValue)")
        guard fs.fileExists(atPath: dest.path), let data = fs.contents(atPath: dest.path), let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
    
    func download(url: URL, completion: @escaping (Result<UIImage, Error>) -> Void) {
        let dest = root.appendingPathComponent("\(url.hashValue)")
        if fs.fileExists(atPath: dest.path), let data = fs.contents(atPath: dest.path), let image = UIImage(data: data) {
            mainThread.success(value: image, completion: completion)
            return
        }
        let task = session.downloadTask(with: url) { [fs, mainThread] (url, resp, error) in
            if let error = error {
                mainThread.failure(error: error, completion: completion)
            } else if let url = url {
                do {
                    try fs.moveItem(at: url, to: dest)
                    guard let data = fs.contents(atPath: dest.path) else {
                        throw ImageDownloadError.imageNotFound
                    }
                    guard let image = UIImage(data: data) else {
                        throw ImageDownloadError.invalidImageData
                    }
                    mainThread.success(value: image, completion: completion)
                } catch {
                    mainThread.failure(error: error, completion: completion)
                }
            }
        }
        task.resume()
    }
}
