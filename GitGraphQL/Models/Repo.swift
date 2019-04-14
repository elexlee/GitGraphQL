//
//  Repo.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/9/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Foundation

class Repo: CustomStringConvertible {
    
    var name: String
    var owner: User
    var starCount: Int
    
    var description: String {
        return "Repo Name: \(self.name) \nOwner: \(self.owner.loginName) \nAvatarURL: \(self.owner.avatarURL) \nStars: \(self.starCount) \n"
    }
    
    init(name: String, owner: User, starCount: Int) {
        self.name = name
        self.owner = owner
        self.starCount = starCount
    }
    
    init(repo: SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository) {
        self.name = repo.name
        self.owner = User(user: repo.owner)
        self.starCount = repo.stargazers.totalCount
    }
}
