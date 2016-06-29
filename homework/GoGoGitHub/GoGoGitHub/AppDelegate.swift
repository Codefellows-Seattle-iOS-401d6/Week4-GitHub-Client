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
    var homeViewController: HomeViewController?

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
                            
                            //making the navigation bar reappear if we are on homeview controller
                            self.homeViewController?.navigationController?.navigationBarHidden = false
                            
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
        //checks to make sure navigation controller is the rootviewcontroller
        guard let navigationController = self.window?.rootViewController as? UINavigationController else {
            fatalError("Check your root view controller")
        }
        //hides navigation bar specifically so it does not show on the login screen
        navigationController.navigationBarHidden = true
        
        guard let homeViewController = navigationController.viewControllers.first as? HomeViewController else {
            fatalError("Home VC?")
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
        
        self.homeViewController = homeViewController
        self.oAuthViewController = oAuthViewController
    }

}

