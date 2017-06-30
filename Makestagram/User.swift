//
//  User.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/28/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase.FIRDataSnapshot

class User: NSObject {
    //MARK: - Properties
    
    let uid: String
    let username: String
    
    //MARK: - Init
    
    init(uid: String, username: String){
        self.uid = uid
        self.username = username
        
        super.init()
    }
    
    //creating failable initializer so if user doesn't have a UID or username it'll fail initialization and return nil
    init?(snapshot: DataSnapshot) {
        
        guard let dict = snapshot.value as? [String : Any],
            let username = dict["username"] as? String
            else { return nil }
        
        self.uid = snapshot.key
        self.username = username
        
        super.init()
    }
    
    //allows user to be decoded form data
    required init?(coder aDecoder: NSCoder) {
        guard let uid = aDecoder.decodeObject(forKey: Constants.UserDefaults.uid) as? String,
            let username = aDecoder.decodeObject(forKey: Constants.UserDefaults.username) as? String
            else { return nil}
        
        self.uid = uid
        self.username = username
        
        super.init()
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
    //Added another parameter that takes a Bool on whether the user should be written to UserDefaults
    class func setCurrent(_ user: User, writeToUserDefaults: Bool = false) {
        
        //Check if boolean value for writeToUserDefaults is true. If so, we write the user object to UserDefaults
        if writeToUserDefaults{
            
            //Use NSKeyedArchiver to turn the user object into data
            let data = NSKeyedArchiver.archivedData(withRootObject: user)
            
            
            //Store the data for the current user with the correct key in UserDefaults
            UserDefaults.standard.set(data, forKey: Constants.UserDefaults.currentUser)
        }
        _current = user
    }
}

extension User: NSCoding {
    func encode(with aCoder: NSCoder) {
        aCoder.encode(uid, forKey:Constants.UserDefaults.uid)
        aCoder.encode(username, forKey: Constants.UserDefaults.username)
    }
}
