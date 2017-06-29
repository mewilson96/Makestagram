//
//  CreateUsernameViewController.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/29/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit

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

    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //create new user in database
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
