//
//  AppDelegate.swift
//  Makestagram
//
//  Created by Mary Wilson on 6/27/17.
//  Copyright © 2017 Mary Wilson. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    // now set to keep user logged in 
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        configureInitialRootViewController(for: window)
        
        //Create an instance of the Login storyboard that has LoginViewController set as its initial view controller
//        let storyboard = UIStoryboard(name: "Login", bundle: .main)
//
//        
//        //Check if storyboard has initial view controller set
//        if let initialViewController = storyboard.instantiateInitialViewController(){
//          
//           
//            
//            //If the storyboard's initial view controller exiests, set it ito the window's rootViewController property
//            window?.rootViewController = initialViewController
//
//            //Position the window above any other existing windows
//            window?.makeKeyAndVisible()
//
//        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
 //Determines which storyboard's initial view controller should be set as rootViewController of the window
extension AppDelegate {
    func configureInitialRootViewController(for window: UIWindow?){
        let defaults = UserDefaults.standard
        let initialViewController: UIViewController
        
        if Auth.auth().currentUser != nil,
            let userData = defaults.object(forKey: Constants.UserDefaults.currentUser) as? Data,
            let user = NSKeyedUnarchiver.unarchiveObject(with: userData) as? User {
        
            User.setCurrent(user)
        
            initialViewController = UIStoryboard.initialViewController(for: .main)
        }
        else {
            initialViewController = UIStoryboard.initialViewController(for: .login)
        }
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
    
    }
}
