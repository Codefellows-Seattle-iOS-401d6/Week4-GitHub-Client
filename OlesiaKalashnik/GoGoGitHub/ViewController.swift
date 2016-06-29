//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/27/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }
    
    @IBAction func loginButtonSelected(sender: UIButton) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user,repo"]) //add repo to the scope
    }
}

extension ViewController : Setup {
    func setup() {
        self.title = "Repositories"
    }
    
    func setupAppearance() {
        self.loginButton.layer.cornerRadius = 3.0
    }
}

