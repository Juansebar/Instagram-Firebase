//
//  User.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 8/17/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import UIKit

struct User {
    
    let uid: String
    let username: String
    let profileImageUrl: String
    
    init(uid: String, _ dictionary: [String: Any]) {
        self.uid = uid
        username = dictionary["username"] as? String ?? ""
        profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
    
}
