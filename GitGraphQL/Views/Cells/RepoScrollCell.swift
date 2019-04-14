//
//  RepoScrollCell.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/9/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import UIKit

class RepoScrollCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: AvatarImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var starCountLabel: UILabel!
    
    
    @IBOutlet weak var numberLabel: UILabel!
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor(colorWithHexValue: 0x353535)
    }
    
    func setup(repo: Repo?) {
        if let repo = repo {
            nameLabel.text = repo.name
            ownerLabel.text = repo.owner.loginName
            starCountLabel.text = String(repo.starCount)
            avatarImageView.backgroundColor = .black
            avatarImageView.configureImage(from: repo.owner.avatarURL)
        }
    }
}
