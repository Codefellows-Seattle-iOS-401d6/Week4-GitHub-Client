//
//  AppDelegate.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/27/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: saveOptions.UserDefaults) { (success) in
            if success {
                print("We have a token!")
            }
        }
        return true
    }
}

