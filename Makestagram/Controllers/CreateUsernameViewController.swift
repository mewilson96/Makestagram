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
        
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else {return}
            
            print("Created new user: \(user.username)")
            
        }
        
    }
    
    
}
