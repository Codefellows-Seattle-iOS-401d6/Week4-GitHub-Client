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
    var viewController: ViewController?
    var homeViewController: HomeViewController?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        self.checkOAuthStatus()
        return true
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        print("AppDelegate - OpenURL Func URL: \(url)")
        
        GitHubOAuth.shared.tokenRequestWithCallback(url, options: SaveOptions.Keychain) { (success) -> () in
            
            if success {
                print("we have token.")
                if let viewController = self.viewController
                {
                    UIView.animateWithDuration(0.4, delay: 1.0, options: .CurveEaseInOut, animations: {
                        viewController.view.alpha = 0.0
                        }, completion: { (finished) in
                            viewController.view.removeFromSuperview()
                            viewController.removeFromParentViewController()
                    })
                }
            }
        }
        return true
    }
    func checkOAuthStatus()
    {
        do
        {
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
        } catch _ {
            self.presentViewController()
        }
    }
    
    func presentViewController()
    {
        guard let homeViewController = self.window?.rootViewController as? HomeViewController else
        {
            fatalError("Check your root view controller.")
        }
        guard let storyboard = homeViewController.storyboard else
        {
            fatalError("Check for storyboard.")
        }
        guard let viewController = storyboard.instantiateViewControllerWithIdentifier(ViewController.id) as? ViewController else
        {
            fatalError("Check scene identifier.")
        }
        homeViewController.addChildViewController(viewController)
        homeViewController.view.addSubview(viewController.view)
        viewController.didMoveToParentViewController(homeViewController)
        self.homeViewController = homeViewController
        self.viewController = viewController
    }
}
