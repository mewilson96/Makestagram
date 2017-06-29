//
//  Storyboard+Utility.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/29/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import UIKit

extension UIStoryboard{
    //creating enum within the UIStoryboard class call MGType
    enum MGType: String{
        
        // contains enum for each of our apps storyboards
        case main
        case login
        
        
        //created a computed variable that capitalized the rawValue of each case
        //the computed variable returns the corresponding filename for each storyboard
        var filename: String {
            return rawValue.capitalized
        }
        
    }
    
    //created a convenience initializer that wil make user of our enum
    convenience init(type:MGType, bundle: Bundle? = nil){
        self.init(name: type.filename, bundle: bundle)
    }
    
    static func initialViewController(for type: MGType) -> UIViewController {
        let storyboard = UIStoryboard(type: type)
        guard let initialViewController = storyboard.instantiateInitialViewController() else {
            fatalError(" Couldn't instantiate initial view controller for \(type.filename) storyboard.")
        }
        return initialViewController
    }
}

