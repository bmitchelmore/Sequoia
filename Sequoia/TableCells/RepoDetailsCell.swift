//
//  RepoDetailsCell.swift
//  Sequoia
//
//  Created by Blair Mitchelmore on 2021-01-13.
//

import Foundation
import UIKit

final class RepoDetailsCell: UITableViewCell {
    @IBOutlet private var avatar: UIImageView!
    @IBOutlet private var name: UILabel!
    @IBOutlet private var owner: UILabel!
    @IBOutlet private var desc: UILabel!
    @IBOutlet private var stars: UILabel!
}

extension RepoDetailsCell {
    func update(with details: RepoDetailsCellViewModel) {
        self.avatar.image = details.avatar
        self.name.text = details.name
        self.owner.text = details.owner
        self.desc.text = details.description
        self.stars.text = "\(details.stars) ⭐️"
    }
}
