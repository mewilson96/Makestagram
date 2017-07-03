//
//  LikeService.swift
//  Makestagram
//
//  Created by Mary Wilson on 7/3/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct LikeService {
    
    static func create (for post: Post, sucess: @escaping (Bool) -> Void) {
        
        // Each posts needs a key, so we're checking that a post has one and if not it returns false
        guard let key = post.key else {
            return sucess(false)
        }
        
        //creating a reference to the current user's UIS
        let currentUID = User.current.uid
        
        //returns a Bool on whether the network request was sucessfully executed and the like data was saved to the database
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(true) {(error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return sucess (false)
            }
            
            return sucess(true)
        }
        
    }
    
    static func delete (for post: Post, sucess: @escaping (Bool) -> Void) {
        // Each posts needs a key, so we're checking that a post has one and if not it returns false
        guard let key = post.key else {
            return sucess(false)
        }
        
        //creating a reference to the current user's UID
        let currentUID = User.current.uid
        
        //returns a Bool on whether the network request was sucessfully executed and the like data was saved to the database
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(nil) {(error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return sucess (false)
            }
            
            return sucess(true)
        }

    }
}
