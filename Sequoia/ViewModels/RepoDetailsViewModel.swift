//
//  RepoDetailsViewModel.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation
import UIKit

final class RepoDetailsViewModel {
    private var search: GraphQL
    private var images: ImageCache
    private var term: String
    
    private var urls: [String:URL] = [:]
    private var lastCursor: String?
    private var loadingMore: Bool = false
    
    private var cells: [RepoDetailsCellViewModel] {
        didSet {
            onCellsUpdated?()
        }
    }
    private var details: [RepoDetails] {
        didSet {
            var urls: [String:URL] = [:]
            self.cells = details.map { details in
                if let avatar = details.owner.avatar, let url = URL(string: avatar) {
                    urls[details.id] = url
                }
                return RepoDetailsCellViewModel(
                    id: details.id,
                    name: details.name,
                    owner: details.owner.name,
                    description: details.description ?? "",
                    avatar: nil,
                    stars: details.stars
                )
            }
            self.urls = urls
        }
    }
    
    var cellCount: Int { cells.count }
    var onCellsUpdated: (() -> Void)? = nil
    
    convenience init(bundle: Bundle = .main) {
        let auth = bundle.object(forInfoDictionaryKey: "GITHUB_AUTH") as? String ?? ""
        self.init(
            search: SimpleGraphQL(auth: auth),
            images: try! SimpleImageCache()
        )
    }
    
    init(search: GraphQL, images: ImageCache) {
        self.search = search
        self.images = images
        
        self.term = "GraphQL"
        self.details = []
        self.lastCursor = nil
        self.loadingMore = true
        self.cells = []
        
        search.queryRepos(search: term) { [weak self] result in
            self?.processSearchResult(result)
        }
    }
    
    private func processSearchResult(_ result: Result<SearchPage<RepoDetails>, Error>) {
        switch result {
        case .success(let results):
            addPage(results)
        case .failure(let error):
            // TODO: Present error to user
            print("Error: \(error)")
        }
        loadingMore = false
    }
    
    private func addPage(_ page: SearchPage<RepoDetails>) {
        lastCursor = page.lastCursor
        details.append(contentsOf: page.results)
    }
    
    private func preloadImage(for id: String) -> UIImage? {
        guard let url = urls[id] else { return nil }
        return images.load(url: url)
    }
    
    private func loadImage(for cell: RepoDetailsCellViewModel) {
        guard let url = urls[cell.id] else { return }
        images.download(url: url) { [weak self] result in
            switch result {
            case .success(_): self?.onCellsUpdated?()
            case .failure(_): break
            }
        }
    }
    
    func cell(forIndex idx: Int) -> RepoDetailsCellViewModel {
        var cell = self.cells[idx]
        cell.avatar = preloadImage(for: cell.id)
        if cell.avatar == nil {
            loadImage(for: cell)
        }
        return cell
    }
    
    func preloadImages(for indices: [Int]) {
        indices
            .map { self.cells[$0] }
            .forEach { self.loadImage(for: $0) }
    }
    
    func loadMore() {
        guard let lastCursor = self.lastCursor else { return }
        guard loadingMore == false else { return }
        loadingMore = true
        search.queryRepos(search: term, after: lastCursor) { [weak self] result in
            self?.processSearchResult(result)
        }
    }
}
