//
//  PostService.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/30/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase

struct PostService {
    
    static func create(for image: UIImage) {
        
        let imageRef = StorageReference.newPostImageReference()
        StorageService.uploadImage(image, at: imageRef) { (downloadURL) in
            guard let downloadURL = downloadURL else{
                return
            }
            let urlString = downloadURL.absoluteString
            let aspectHeight = image.aspectHeight
            create(forURLString: urlString, aspectHeight: aspectHeight)
        }
    }
    
    private static func create(forURLString urlString: String, aspectHeight: CGFloat){
        
        //create reference to the current user
        let currentUser = User.current
        
        //initialize a new post useing the data passed in by the parameters
        let post = Post(imageURL: urlString, imageHeight: aspectHeight)
        
        //create references to the important location that we're planning to write data
        let rootRef = Database.database().reference()
        let newPostRef = rootRef.child("posts").child(currentUser.uid).childByAutoId()
        let newPostKey = newPostRef.key
        
        //use class method to get an array of all of the follower UIDs
        UserService.followers(for: currentUser) { (followerUIDs) in
            
            //contrunct a timeline JSON object where we store the current' user's uid. needed because when we fetch a timeline for a given user, we'll need the uid of the post in order to read the post from the Post subtree
            let timelinePostDict = ["poster_uid": currentUser.uid]
            
            //create a mutable dictinary that will store all of the data we want to write to our database. initialize it by writing the current timeline dictionary to our own timeline b/c our own uid will be excluded from our follwer UIDs
            var updatedData: [String : Any] = ["timeline/\(currentUser.uid)/\(newPostKey)" : timelinePostDict]
            
            //add our post to each of our follower's timelines
            for uid in followerUIDs {
                updatedData["timeline/\(uid)/\(newPostKey)"] = timelinePostDict
            }
            
            //we make sure to write the post we are trying to create
            let postDict = post.dictValue
            updatedData["posts/\(currentUser.uid)/\(newPostKey)"] = postDict
            
            //we write our multi-location update to our database
            rootRef.updateChildValues(updatedData)
        }
            
            
    }
    
    static func show(forKey postKey: String, posterUID: String, completion: @escaping (Post?) -> Void) {
        
        let ref = Database.database().reference().child("posts").child(posterUID).child(postKey)
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            guard let post = Post(snapshot: snapshot) else {
                return completion(nil)
            }
        
            LikeService.isPostLiked(post) { (isLiked) in
                post.isLiked = isLiked
                completion(post)
            }
        })
    }
}
