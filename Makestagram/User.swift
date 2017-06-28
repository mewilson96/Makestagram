//
//  User.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/28/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import FirebaseDatabase.FIRDataSnapshot

class User {
    //MARK: - Properties
    
    let uid: String
    let username: String
    
    //MARK: - Init
    
    init(uid: String, username: String){
        self.uid = uid
        self.username = username
    }
    
    //creating failable initializer so if user doesn't have a UID or username it'll fail initialization and return nil
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
    }
}
