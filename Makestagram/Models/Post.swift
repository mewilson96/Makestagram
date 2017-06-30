//
//  File.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/30/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import  FirebaseDatabase.FIRDataSnapshot

class Post {
    
    var key: String?
    let imageURL: String
    let imageHeight: CGFloat
    let creationDate: Date
    
    init(imageURL: String, imageHeight:CGFloat){
        self.imageURL = imageURL
        self.imageHeight = imageHeight
        self.creationDate = Date()
    }
    
    var dictValue: [String: Any] {
        
        let createdAgo = creationDate.timeIntervalSince1970
        
        return ["image_url": imageURL,
                "image_height": imageHeight,
                "created_at": createdAgo]
    }
}
