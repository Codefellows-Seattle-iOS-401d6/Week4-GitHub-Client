//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/27/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func requestToken(sender: UIButton) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user"])
    }
    
    @IBAction func printAccessToken(sender: UIButton) {
        do {
            let token = try GitHubOAuth.shared.accessToken()
            print("Access Token: \(token)")
        } catch let error {
            print(error)
        }
    }
    
}

