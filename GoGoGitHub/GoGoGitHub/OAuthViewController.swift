//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Erin Roby on 6/27/16.
//  Copyright © 2016 Erin Roby. All rights reserved.
//

import UIKit

class OAuthViewController: UIViewController, Setup  {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LoginButtonSelected(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user,repo"])
    }
    func setup() {
        self.title = "Repositories"
    }
    
    func setupAppearance() {
        self.loginButton.layer.cornerRadius = 3.0
    }
}

//extension OAuthViewController: Setup {
//    func setup() {
//        self.title = "Repositories"
//    }
//    
//    func setupAppearance() {
//        self.loginButton.layer.cornerRadius = 3.0
//    }
//}

