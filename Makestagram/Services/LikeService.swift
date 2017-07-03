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
    
    static func create (for post: Post, success: @escaping (Bool) -> Void) {
        
        // Each posts needs a key, so we're checking that a post has one and if not it returns false
        guard let key = post.key else {
            return success(false)
        }
        
        //creating a reference to the current user's UIS
        let currentUID = User.current.uid
        
        //returns a Bool on whether the network request was sucessfully executed and the like data was saved to the database
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(true) {(error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success (false)
            }
            
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")

            //call the transaction API on the DatabaseReference location we want to update
            likeCountRef.runTransactionBlock({ (mutableData) -> TransactionResult in
                
                //Check that the value exists and increment it if it does
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount + 1
                
                //Return the updated value
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                
                //Handle the completion block if there's an error
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                    
                }else {
                    success(true)
                    
                }
            })
        }
        
        
    }
    
    static func delete (for post: Post, success: @escaping (Bool) -> Void) {
        // Each posts needs a key, so we're checking that a post has one and if not it returns false
        guard let key = post.key else {
            return success(false)
        }
        
        //creating a reference to the current user's UID
        let currentUID = User.current.uid
        
        //returns a Bool on whether the network request was sucessfully executed and the dislikelike data was saved to the database
        let likesRef = Database.database().reference().child("postLikes").child(key).child(currentUID)
        likesRef.setValue(nil) {(error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return success (false)
            }
            
            let likeCountRef = Database.database().reference().child("posts").child(post.poster.uid).child(key).child("like_count")
            
            //call the transaction API on the DatabaseReference location we want to update
            likeCountRef.runTransactionBlock( { (mutableData) -> TransactionResult in
                
                //Check that the value exists and decrement it if it does
                let currentCount = mutableData.value as? Int ?? 0
                mutableData.value = currentCount - 1
                
                //Return the updated value
                return TransactionResult.success(withValue: mutableData)
            }, andCompletionBlock: { (error, _, _) in
                
                //Handle the completion block if there's an error
                if let error = error {
                    assertionFailure(error.localizedDescription)
                    success(false)
                } else {
                    success(true)
                }
            })
        }
    }
    
    static func setIsLike(_ isLiked: Bool, for post: Post, success: @escaping (Bool) -> Void) {
        if isLiked {
        create(for: post, success: success)
        
        }else {
        
        delete(for: post, success: success)
        }
    }
    
    static func isPostLiked(_ post: Post, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        //make sure that the post has a key
        guard let postKey = post.key else {
            assertionFailure("Error: post must have key.")
            return completion(false)
        }
        
        //build a relative path to the location of where we store the current user's like data for specific post, if a like were to exist
        let likesRef = Database.database().reference().child("postLikes").child(postKey)
        
        //use a special query that checks whether a value exists at the location that we're reading from. if there is, we know that the current use has liked the post
        likesRef.queryEqual(toValue: nil, childKey: User.current.uid).observeSingleEvent(of: .value, with: {(snapshot) in
            
            if let _ = snapshot.value as? [String: Bool] {
                completion(true)
            } else {
                completion(false)
                
            }
        })
    }
}
