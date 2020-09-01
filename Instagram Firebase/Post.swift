//
//  Post.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/1/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import Foundation

struct Post {
    
    let imageUrl: String
    
    init(dictionary: [String: Any]) {
        imageUrl = dictionary["imageUrl"] as? String ?? ""
    }
    
}
