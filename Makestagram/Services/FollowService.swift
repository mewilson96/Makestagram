//
//  FollowService.swift
//  Makestagram
//
//  Created by Mary Wilson on 7/3/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FollowService {

    private static func followUser(_ user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void){
        
        //create a dictionary to update multiple locations at the same time. We set the appropriate key- value for our follows and following
        let currentUID = User.current.uid
        let followData = ["followers/\(user.uid)/\(currentUID)": true,
                          "following/\(currentUID)/\(user.uid)": true]
        
        //we write our relationship to Firebase
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                success(false)
            }
            
            //get all posts for the user
            UserService.posts(for:user) { (posts) in
                
                //get all all of the post keys for that user's
                let postKeys = posts.flatMap { $0.key }
                
                //we build a multiple location update using a dictionary that adds each of the followee's post to our timeline
                var followData = [String : Any]()
                let timelinePostDict = ["poster_uid" : user.uid]
                postKeys.forEach { followData["timeline/\(currentUID)/\($0)"] = timelinePostDict }
                
                //we write the dictionary to our database
                ref.updateChildValues(followData, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    //return whether the update was sucessful based on whether there was an error
                    success(error == nil)
                    
                })
            }
        }
    }
    
    private static func unfollowUser(_  user: User, forCurrentUserWithSuccess success: @escaping (Bool) -> Void) {
        let currentUID = User.current.uid
        // Use NSNull() object instead of nil because updateChildValues expects type [Hashable : Any]
        //http://stackoverflow.com/questions/38462074/using-updatechildvalues-to-delete-from-firebase
        let followData = ["followers/\(user.uid)/\(currentUID)" : NSNull(),
                          "following/\(currentUID)/\(user.uid)" : NSNull()]
        
        let ref = Database.database().reference()
        ref.updateChildValues(followData) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
            
            UserService.posts(for: user, completion: { (posts) in
                var unfollowData = [String: Any]()
                let postsKeys = posts.flatMap { $0.key }
                postsKeys.forEach {
                    
                    //Use NSNull() object instead of nil because updatedChildValues expects type [Hashable: Any]
                    unfollowData["timeline/\(currentUID)/\($0)"] = NSNull()
                    
                }
                
                ref.updateChildValues(unfollowData, withCompletionBlock: { (error, ref) in
                    if let error = error {
                        assertionFailure(error.localizedDescription)
                    }
                    
                    success(error == nil)
                })
            })
        }
    }
    
    static func setIsFollowing(_ isFollowing: Bool, fromCurrentUserTo followee: User, success: @escaping (Bool) -> Void) {
        if isFollowing {
            followUser(followee, forCurrentUserWithSuccess: success)
        } else {
            unfollowUser(followee, forCurrentUserWithSuccess: success)
        }
    }
    
    static func isUserFollowed(_ user: User, byCurrentUserWithCompletion completion: @escaping (Bool) -> Void) {
        
        let currentUID = User.current.uid
        let ref = Database.database().reference().child("followers").child(user.uid)
        
        ref.queryEqual(toValue: nil, childKey: currentUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? [String:  Bool] {
                completion(true)
         
            }else {
                completion(false)
            }
        
        })
    }

}
