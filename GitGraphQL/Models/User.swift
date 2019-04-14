//
//  User.swift
//  GitGraphQL
//
//  Created by Elex Lee on 4/9/19.
//  Copyright © 2019 Elex Lee. All rights reserved.
//

import Foundation

class User {
    
    var loginName: String
    var avatarURL: String
    
    init(loginName: String, avatarURL: String) {
        self.loginName = loginName
        self.avatarURL = avatarURL
    }
    
    init(user: SearchRepositoriesQuery.Data.Search.Edge.Node.AsRepository.Owner) {
        self.loginName = user.login
        self.avatarURL = user.avatarUrl
    }
}
