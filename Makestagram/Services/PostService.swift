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
        
        //convert the new post object into a dictionary so it can be written as JSON in our database
        let dict = post.dictValue
        
        //construct the relative path to the location where we want to store the new post data
        let postRef = Database.database().reference().child("posts").child(currentUser.uid).childByAutoId()
        
        //write the data to the specified location
        postRef.updateChildValues(dict)
    }
}
