//
//  AppDelegate.swift
//  GoGoGitHub
//
//  Created by Erin Roby on 6/27/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var oAuthViewController: OAuthViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.checkOAuthStatus()
        return true
    }

    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenUrl Func URL: \(url)")
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.userDefaults) { (success) in
            if success  {
                print("We have a token!!!") // we have a token so let's remove the login view
                if let oAuthViewController = self.oAuthViewController {
                    UIView.animateWithDuration(0.4, delay: 1.0, options: .CurveEaseOut, animations: {
                        oAuthViewController.view.alpha = 0.0 }, completion: { (finished) in
                            oAuthViewController.view.removeFromSuperview()
                            oAuthViewController.removeFromParentViewController()
                    })
                }
            }
        }
        return true
    }
    
    func checkOAuthStatus () {
        do {
            if let token = try GitHubOAuth.shared.accessToken() { print(token) }
        } catch {
            self.presentOAuthViewController()
        }
    }
    
    func presentOAuthViewController() {
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else {
            fatalError("Check your root view controller...")
        }
        
        guard let storyboard = homeViewController.storyboard else { fatalError("Check for storyboard!") }
        
        guard let oAuthViewController = storyboard.instantiateViewControllerWithIdentifier(OAuthViewController.id) as? OAuthViewController else {
            fatalError("Check scene identifier.")
        }
        
        homeViewController.addChildViewController(oAuthViewController)
        homeViewController.view.addSubview(oAuthViewController.view)
        oAuthViewController.didMoveToParentViewController(homeViewController)
        
        self.oAuthViewController = oAuthViewController
    }
}

