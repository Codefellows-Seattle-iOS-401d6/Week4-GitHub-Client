//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Jess Malesh on 6/27/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    @IBAction func requestToken(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope" :"email,user"])
        
    }
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }


    @IBAction func printToken(sender: AnyObject) {
        do{
            let token = try GitHubOAuth.shared.accessToken()
            print(token)
            
        } catch let error {
            print(error)
        }
    }
}

