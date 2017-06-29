//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/29/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {

    //MARK: - Subviews
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        nextButton.layer.cornerRadius = 6
    }
    //MARK: - IBActions
    
    //create new user in database
    //whenever a user is created, a user JSON  object will also be created for them within our database
    @IBAction func nextButtonTapped(_ sender: UIButton) {
       
        //Check to see if FIRUser is logged in and that they have provided  a username in the textfield
        guard let firUser = Auth.auth().currentUser,
            let username = usernameTextField.text,
            !username.isEmpty else { return }
        
        //created a dictionary to store the username that the user provided to the database
        let userAttrs = ["username": username]
        
        //Specifying  a relative path for the location of where we want to stor the user's data
        let ref = Database.database().reference().child("users").child(firUser.uid)
        
        
        //write the data I want to store at the location  we provided above
        ref.setValue(userAttrs) { (error, ref) in
            if let error = error {
                assertionFailure(error.localizedDescription)
                return
            }
            
            //read the user that was just written into the database and create a user from the snapshot
            ref.observeSingleEvent(of: .value, with: { (snapshot) in
                let user = User(snapshot: snapshot)
            
            })
        }
        
    }
    
    
}
