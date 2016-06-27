//
//  AppDelegate.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/27/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.userDefaults) { (success) in
            
            if success {
                print("we have token.")
            }
        }
        return true
    }
}
