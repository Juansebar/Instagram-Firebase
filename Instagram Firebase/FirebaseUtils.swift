//
//  FirebaseUtils.swift
//  Instagram Firebase
//
//  Created by Juan Ramirez on 9/26/20.
//  Copyright © 2020 Sebapps. All rights reserved.
//

import Firebase

extension Database {
    
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> Void) {
        let userReference = Database.database().reference().child("users").child(uid)
        userReference.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userDictonary = snapshot.value as? [String: Any] else { return }
            
            let user = User(uid: uid, userDictonary)
            completion(user)
        }) { (error) in
            print("Failed to fetch user for posts:", error)
        }
    }
    
}
