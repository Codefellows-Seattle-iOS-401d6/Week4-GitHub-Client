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

    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonWasSelected(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user,repo"])
    }
    

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }

}

extension ViewController: Setup
{
    
    //mark setup
    
    func setup()
    {
        self.title = "Repositories"
    }
    
    func setupAppearance()
    {
        self.loginButton.layer.cornerRadius = 3.0
    }

}

























