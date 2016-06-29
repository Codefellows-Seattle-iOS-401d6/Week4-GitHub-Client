//
//  ViewController.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/27/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit
//caled OAuthViewController w Michael

class ViewController: UIViewController, Setup {

    @IBOutlet weak var loginButton: UIButton!
    
//    lazy var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setup() {
        //
        self.title = "Repositories"
    }
    func setupAppearance() {
        //
        self.loginButton.layer.cornerRadius = 3.0
    }
    
    
    @IBAction func loginButtonSelected(sender: UIButton) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user,repo"])
    }
   
}


