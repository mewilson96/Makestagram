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
            return
        }
        print("handle user signup / login")
    }
}
