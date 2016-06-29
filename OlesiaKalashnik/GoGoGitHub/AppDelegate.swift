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
    var oAuthVC : ViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        self.checkOAuthStatus()
        return true
    }
    
    func checkOAuthStatus() {
        do {
            if let token = try GitHubOAuth.shared.accessToken() {
                print("TOKEN!!! \(token)")
            } else {
                presentOAuthViewController()
            }
        } catch {
            print("Catching")
            
        }
    }
    
    
    func presentOAuthViewController() {
        guard let HomeVC = self.window?.rootViewController as? HomeViewController else {
            fatalError("Check root VC") }
        guard let storyboard = HomeVC.storyboard else { fatalError("Check for storyboard") }
        guard let oAuthViewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else {
            fatalError("Check scene id")
        }
        HomeVC.addChildViewController(oAuthViewController)
        HomeVC.view.addSubview(oAuthViewController.view)
        oAuthViewController.didMoveToParentViewController(HomeVC)
        self.oAuthVC = oAuthViewController
    }
    
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: saveOptions.Keychain) { (success) in
            if success {
                if let oAuthVC = self.oAuthVC {
                    UIView.animateWithDuration(0.5, delay: 1.0, options: .CurveEaseOut, animations: {
                        oAuthVC.view.alpha = 0.0
                        }, completion: { (finished) in
                            oAuthVC.view.removeFromSuperview()
                            oAuthVC.removeFromParentViewController()
                    })
                }
            }
        }
        return true
    }
}

