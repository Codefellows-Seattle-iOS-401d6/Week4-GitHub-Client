//
//  AppDelegate.swift
//  GitGit
//
//  Created by Derek Graham on 6/27/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var oauthViewController: ViewController?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        self.checkOAuthStatus()
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("appdelegate - OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.Keychain) { (success) in
            
            if success {
                if let oauthViewController = self.oauthViewController {
                    UIView.animateWithDuration(0.4, delay: 1.0, options: .CurveEaseInOut, animations: {
                        oauthViewController.view.alpha = 0.0
                        }, completion: { (finished) in
                            oauthViewController.view.removeFromSuperview()
                            oauthViewController.removeFromParentViewController()
                           
                            API.shared.getToken()
                            guard let homeViewController = self.window?.rootViewController as? HomeViewController else { return }
                            
                            homeViewController.getRepos()

                    })
                }
                print("We have a token")
                
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
        catch { self.presentOAuthViewController()}
    }
    
    func presentOAuthViewController()
        
    {
        
        // Change ViewController references to OAuthViewController or ...
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else {
            fatalError("check your root view controller...")
        }
        
        guard let storyboard = homeViewController.storyboard else {
            fatalError("Check for storyboard") }
        
        guard let oauthViewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else {
            fatalError("Check scene identifier")
        }
        homeViewController.addChildViewController(oauthViewController)
        homeViewController.view.addSubview(oauthViewController.view)
        
        
        oauthViewController.didMoveToParentViewController(homeViewController)
        
        self.oauthViewController = oauthViewController
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

