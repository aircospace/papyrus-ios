////
//  Message.swift
//  Papyrus
//
//  Created by Victor Shinya on 30/07/17.
//  Copyright © 2017 aKANJ. All rights reserved.
//

import Foundation

class User {
    
    var userId: String = ""
    
    static let currentUser: User = {
        let user = User()
        user.userId = "23333"
        return user
    }()
    
}
