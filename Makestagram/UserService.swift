//
//  UserService.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/29/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import FirebaseAuth.FIRUser
import FirebaseDatabase

struct UserService {
    
    static func followers(for user: User, completion: @escaping ([String]) -> Void) {
        let followersRef = Database.database().reference().child("followers").child(user.uid)
        
        followersRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let followersDict = snapshot.value as? [String: Bool] else {
                return completion([])
            }
                let followersKeys = Array(followersDict.keys)
                completion(followersKeys)
        })
    }
    static func create(_ firUser: FIRUser, username: String, completion: @escaping (User?) -> Void) {
        
        //creating a dictionary to store the username that the user provided to the database
        let userAttrs = ["username": username]
        
        //Specifying  a relative path for the location of where we want to stor the user's data
        let ref = Database.database().reference().child("users").child(firUser.uid)
       
        //write the data I want to store at the location  we provided above
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            
            //read the user that was just written into the database and create a user from the snapshot
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
                completion(user)
            })
        }
    }
    static func show(forUID uid: String, completion: @escaping (User?) -> Void){
        let ref = Database.database().reference().child("users").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let user = User(snapshot: snapshot) else {
                return completion(nil)
            }
            completion(user)
        })
    }
    
    //method that will fetch and return all of our posts from Firbase from a given use which can be used to display posts we've made so far
    static func posts(for user: User, completion: @escaping ([Post]) -> Void) {
        
        let ref = Database.database().reference().child("posts").child(user.uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot] else {

                return completion([])
            }
           let dispatchGroup = DispatchGroup()
            let posts: [Post] =
                snapshot
                    .reversed()
                    .flatMap{
                        guard let post = Post(snapshot: $0)
                            else { return nil }
                        
                        dispatchGroup.enter()
                        
                        LikeService.isPostLiked(post) { (isLiked) in
                            post.isLiked = isLiked
                            
                            dispatchGroup.leave()
                        }
                        
                        return post
                    }
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts)
                
            })
            
            
        })
    }
    
    static func timeline(completion: @escaping ([Post]) -> Void) {
        let currentUser = User.current
        
        let timelineRef = Database.database().reference().child("timeline").child(currentUser.uid)
        timelineRef.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else {return completion([]) }
        
            let dispatchGroup = DispatchGroup()
        
            var posts = [Post]()
        
            for postSnap in snapshot {
                guard let postDict = postSnap.value as? [String: Any],
                    let posterUID = postDict["poster_uid"] as? String
                    else { continue }
        
                dispatchGroup.enter()
        
                PostService.show(forKey: postSnap.key, posterUID: posterUID) { (post) in
                    if let post = post {
                        posts.append(post)
                    }
        
                    dispatchGroup.leave()
                }
            }
        
            dispatchGroup.notify(queue: .main, execute: {
                completion(posts.reversed())
        
            })
        })
    }
    
    static func usersExcludingCurrentUser(completion: @escaping ([User]) -> Void) {
        let currentUser = User.current
        
        //create a DatabaseReference to read all users from the database
        let ref = Database.database().reference().child("users")
        
        //read the users node from the database
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let snapshot = snapshot.children.allObjects as? [DataSnapshot]
                else { return completion([]) }
            
            //take snapshot and convert all the child DataSnapshot into User using our failable initializer then filter out the currentuser objevt from the User array
            let users =
                snapshot
                    .flatMap(User.init)
                    .filter {$0.uid != currentUser.uid }
            
            //create a new DispatchGroup so that we can be notified when all asynchronous taks are finished executing. using the notify(queue:) method on DispatchGroup as a completion handler for when all follow data has been read
            let dispatchGroup = DispatchGroup()
            users.forEach { (user) in
                dispatchGroup.enter()
                
                //make a request for each individual user to determine if the user if being followed by current user
                FollowService.isUserFollowed(user) { (isFollowed) in
                    user.isFollowed = isFollowed
                    dispatchGroup.leave()
                }
            }
            
            //run the completion block after all follow relationship data has returned
            dispatchGroup.notify(queue: .main, execute: {
                completion(users)
            })
        })
    }
}
