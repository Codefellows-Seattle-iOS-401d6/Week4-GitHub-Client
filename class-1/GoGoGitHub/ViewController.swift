//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/27/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func requestToken(sender: AnyObject) {
        
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user"])
    }

    @IBAction func printToken(sender: AnyObject) {
        do {
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
        } catch let error {
            print(error)
        }
    }
}

