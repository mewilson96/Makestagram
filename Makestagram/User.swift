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
    
    //MARK: - Singleton
    
    //private static variable to hold the current user
    private static var _current: User?
    
    //creating a computed variable that only has a getter that can access the private _current variable
    static var current: User{
        
        //check that _current that is of type User? isn't nil. If _current is nil, and current is being read, the guard statement will crash with fatalError()
        guard let currentUser = _current else {
            fatalError("Error: current user doesn't exist")
        }
        
        //if _current isn't nil, it'll be returned to the user
        return currentUser
    }
    
    static func setCurrent(_ user: User) {
        _current = user
    }
}
