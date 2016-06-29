//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/27/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func requestToken(sender: AnyObject) {
        
        GitHubOAuth.shared.oAuthRequestWith(["scope": "repo,email,user"])
    }
    
    lazy var refreshControl = UIRefreshControl()
}

extension ViewController: Setup
{
    func setup()
    {
        self.title = "Repositories"
//        self.refreshControl.addTarget(self, action: #selector(HomeViewController.update), forControlEvents: .AllEvents)
//        self.tableView.addSubview(self.refreshControl)
    }
    
    func setupAppearance()
    {
   //     self.loginButton.layer.cornerRadius = 3.0
    }
}

