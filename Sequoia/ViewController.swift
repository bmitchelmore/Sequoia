//
//  ViewController.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    @IBOutlet private var tableView: UITableView!
    
    private let viewModel = RepoDetailsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.onCellsUpdated = { [weak self] () in
            guard let tableView = self?.tableView else { return }
            let offset = tableView.contentOffset
            tableView.reloadData()
            tableView.contentOffset = offset
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.cellCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RepoDetailsCell", for: indexPath) as? RepoDetailsCell else {
            preconditionFailure("Shouldn't ever happen!")
        }
        let data = viewModel.cell(forIndex: indexPath.item)
        cell.update(with: data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.preloadImages(for: indexPaths.map({ $0.item }))
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y + scrollView.frame.height > (scrollView.contentSize.height - scrollView.frame.height) {
            viewModel.loadMore()
        }
    }
}

