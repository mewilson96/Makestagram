//
//  MainTabController.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/30/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import Foundation
import UIKit

class MainTabBarController: UITabBarController  {
    
    
    //MARK: Properties
    
    //creating an instance of MFPhotoHelper
    let photoHelper = MGPhotoHelper()
    
    //MARK: VC Lifestyle
    
    override func viewDidLoad(){
       
        super.viewDidLoad()
        
        photoHelper.completionHandler = { image in
            print("handle image")
        }
        
        //Set the MainTabController as the delegate of it's tab bar
        delegate = self
        
        //Set the tab bar's unselectedItemTint Color from the default of gray to black
        tabBar.unselectedItemTintColor = .black
    }
}

extension MainTabBarController: UITabBarControllerDelegate{
    
    //should select returns a Bool that determines if the tab bar will present the corresponding UIViewController
    //If true, the tab bar will behave as usual if not the view controller won't be displayed
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        if viewController.tabBarItem.tag == 1 {
            
            //present photo taking action sheet
            photoHelper.presentActionSheet(from: self)
            
            return false
        }
        return true
    }
}
