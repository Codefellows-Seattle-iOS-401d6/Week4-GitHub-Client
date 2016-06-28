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
    
    var oauthViewController: ViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.checkOAuthStatus()
        
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.userDefaults) { (success) in
            
            if success {
                
                // remove login view
                
                if let oauthViewController = self.oauthViewController {
                    UIView.animateWithDuration(0.4, delay: 1.0, options: .CurveEaseInOut, animations: {
                        oauthViewController.view.alpha = 0.0
                        }, completion: { (finished) in
                            oauthViewController.view.removeFromSuperview()
                            oauthViewController.removeFromParentViewController()
                    })
                }
                print("we have a token!!")
            }
            
        }
        return true
    }
    
    func checkOAuthStatus() {
        
        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                print(token)
            }
        }
        
        catch { self.presentOAuthViewController() }
    }
    
    func presentOAuthViewController() {
        
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else {
            fatalError("Check your root view controller...")
        }
        
        guard let storyboard = homeViewController.storyboard else {
            fatalError("check for storyboard...")
        }
        
        guard let oauthViewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else {
            fatalError("Check scene identifier...")
        }
        
        homeViewController.addChildViewController(oauthViewController)
        homeViewController.view.addSubview(oauthViewController.view)
        oauthViewController.didMoveToParentViewController(homeViewController)
        
        self.oauthViewController = oauthViewController
    }
    
}

