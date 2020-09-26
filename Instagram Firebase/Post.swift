//
//  Post.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/1/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        imageUrl = dictionary["imageUrl"] as? String ?? ""
        caption = dictionary["caption"] as? String ?? ""
    }
    
}
