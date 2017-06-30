//
//  StorageService.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/30/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import FirebaseStorage

struct StorageService{
    
    static func unploadImage(_ image: UIImage, at reference: StorageReference, completion: @escaping (URL?) -> Void){
        
        //change the image from an UIImage to Data to reduce the quality of the image  to reduce upload/ download time
        guard let imageData = UIImageJPEGRepresentation(image, 0.1 ) else{
            return completion(nil)
        }
        
        //upload our media data to the path provided as a parameter to the method
        reference.putData(imageData, metadata: nil, completion: { (metadata, error) in
            
            //Check fi there was an error after upload
            if let error = error {
                assertionFailure(error.localizedDescription)
                return completion(nil)
            }
            //if everything is successful, return the download URL for the image
            completion(metadata?.downloadURL())
        })
    }
}
