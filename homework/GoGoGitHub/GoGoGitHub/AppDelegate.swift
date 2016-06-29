//
//  AppDelegate.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/27/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var oAuthViewController: ViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        checkOAuthStatus()
        
        return true
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        print("AppDelegate-OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.Keychain) { (success) in
                if success {
                    if let oAuthViewController = self.oAuthViewController {
                        UIView.animateWithDuration(0.4, delay: 1.0, options: .CurveEaseInOut, animations: { 
                            oAuthViewController.view.alpha = 0.0
                            }, completion: { (finished) in
                                oAuthViewController.view.removeFromSuperview()
                                oAuthViewController.removeFromParentViewController()
                                
                                API.shared.getToken()
                                guard let homeViewController = self.window?.rootViewController as? HomeViewController else { return }
                                homeViewController.getRepos()
                                
                        })
                    }
                } else {
                    print("no token")
                }
        }
        return true
    }
    
    func checkOAuthStatus() {
        do {
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
        } catch {
            self.presentOAuthViewController()
        }
    }
    
    func presentOAuthViewController() {
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else {
            fatalError("Check your root view controller")
        }
        
        guard let storyboard = homeViewController.storyboard else {
            fatalError("Check for storyboard")
        }
        
        guard let oAuthViewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else {
            fatalError("Check scene identifier")
        }
        
        homeViewController.addChildViewController(oAuthViewController)
        homeViewController.view.addSubview(oAuthViewController.view)
        oAuthViewController.didMoveToParentViewController(homeViewController)
        
        self.oAuthViewController = oAuthViewController
    }

}

