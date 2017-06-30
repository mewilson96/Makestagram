//
//  MGPhotoHelper.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/30/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit

class MGPhotoHelper: NSObject {
    
    //MARK: - Properties
    
    //completionHandler will be called when the user has selected a photo from UIImagePickerController
    var completionHandler: ((UIImage) -> Void)?
    
    //MARK: - Helper Methods
    
    //takes a reference to a view controller as a reference. it's necessary b/c the MGPhotoHelper needs a UIViewController  on which it can present other view controllers
    func presentActionSheet(from viewController: UIViewController) {
        
        
        //initialize a new UIAlertController of type actionsheet. can be used to present different types of alerts
        let alertController = UIAlertController(title: nil, message: "Where do you want to get your picture from?", preferredStyle: .actionSheet)
        
        //Check if the current device has a camera available
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            
            //new UIAlertAction
            let capturePhotoAction = UIAlertAction(title: "Take Photo", style: .default, handler: { action in
                
            })
            //add action to the alerController instance created
            alertController.addAction(capturePhotoAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let uploadAction = UIAlertAction(title: "Upload from Library", style: .default, handler: {action in
                
            })
            alertController.addAction(uploadAction)
        }
        
        //add a cancel action to allow user to close the UIAlertController action sheet
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        //present the UIAlertController from  the UIViewController
        viewController.present(alertController, animated: true)
    }
}
