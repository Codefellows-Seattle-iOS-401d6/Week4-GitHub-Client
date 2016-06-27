//
//  AppDelegate.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/27/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : Anyobject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallBack(url, options: SaveOptions.userDefaults { (success) in
            
            if success {
                print("we have a token!!")
            }
            
            
        }
            return true
        }
    }
    
}

