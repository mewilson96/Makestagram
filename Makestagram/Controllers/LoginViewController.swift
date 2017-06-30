//
//  LoginViewController.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/28/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    //MARK - Properties
    @IBOutlet weak var loginButton: UIButton!
    
    //MARK -VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    //MARK - IBActions
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login Button Tapped")
        
        //access the FUIAuth default auth UI singleton
        guard let authUI = FUIAuth.defaultAuthUI()
            else {return}
        
        //set FUITAuth's singleton delegate
        //set LoginViewController to be a delegate of authUI
        authUI.delegate = self
        
        //present the auth view controller
        //when presented Firebase presents its own UI to handle loggin in the user
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true)
    }
    
}

extension LoginViewController: FUIAuthDelegate {
    
    //Adding FirebaseAuth.User prevents namespace conflicts to which USer type we're referring to in the code
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        
        if let error = error {
            assertionFailure("Error sign in: \(error.localizedDescription)")
            
        }
        //making sure FIRUser has been authenticated with FirebaseAuth and it's not nil
        guard let user = user
            else{ return }
        
        //Create a relative path to the reference of the user's information
        let userRef = Database.database().reference().child("users").child(user.uid)
        
        //Read the path that was created and pass an event closure to handle the data thatis passed back from the databaseNat
        userRef.observeSingleEvent(of: .value, with: { [unowned self] (snapshot) in
            
            //Checking that the snapshot exists
            //For users already in the system so they can go to the main storyboard after they've logged in
            UserService.show(forUID: user.uid) { (user) in
                if let user = user {
                    
                    //handle existing user
                    User.setCurrent(user, writeToUserDefaults: true)
                    
                    //Create a new instance of our main storyboard
                    //setting storyboard  to equal Main.storyboard
                    
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                    
                }
                else{
                    self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                }
                
            }
            
        })
    }
}
