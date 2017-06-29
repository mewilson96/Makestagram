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
        
        //calling Userservice to create a username in the database
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else {
                return
            }
            
            User.setCurrent(user)
            
            //Create a new instance of our main storyboard
            //setting storyboard  to equal Main.storyboard
            let storyboard =  UIStoryboard(name: "Main", bundle: .main)
            
            //getting reference to the current window and set the rootViewController to the initial view controller
            if let initialViewController = storyboard.instantiateInitialViewController(){
                self.view.window?.rootViewController = initialViewController
                self.view.window?.makeKeyAndVisible()
            }
        }
        
    }
    
    
}
