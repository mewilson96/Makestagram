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
    
}
