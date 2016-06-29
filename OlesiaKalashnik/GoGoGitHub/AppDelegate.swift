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
    var homeVC : HomeViewController?
    
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
        guard let navVC = self.window?.rootViewController as? UINavigationController else { fatalError("Check root VC") }
        navVC.navigationBarHidden = true
        guard let HomeVC = navVC.viewControllers.first as? HomeViewController else { fatalError("Check if HomeVC is the top VC in NavigationVC") }
        guard let storyboard = HomeVC.storyboard else { fatalError("Check for storyboard") }
        guard let oAuthViewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else { fatalError("Check scene id") }
        
        HomeVC.addChildViewController(oAuthViewController)
        HomeVC.view.addSubview(oAuthViewController.view)
        oAuthViewController.didMoveToParentViewController(HomeVC)
        
        self.oAuthVC = oAuthViewController
        self.homeVC = HomeVC
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: saveOptions.Keychain) { (success) in
            if success {
                API.shared.setupToken()
                if let oAuthVC = self.oAuthVC {
                    UIView.animateWithDuration(0.5, delay: 1.0, options: .CurveEaseOut, animations: {
                        self.homeVC?.navigationController?.navigationBarHidden = false
                        oAuthVC.view.alpha = 0.0
                        }, completion: { (finished) in
                            oAuthVC.view.removeFromSuperview()
                            oAuthVC.removeFromParentViewController()
                            self.homeVC?.update()
                    })
                }
            }
        }
        return true
    }
}

