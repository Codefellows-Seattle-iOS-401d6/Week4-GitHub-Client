//
//  ViewController.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/27/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func loginButtonSelected(sender: AnyObject) {
        GitHubOAuth.shared.oAuthRequestWith(["scope": "email,user,repo"])
    }

}

extension ViewController: Setup {
    func setup() {
        self.title = "Repositories"
    }
    
    func setupAppearance() {
        self.loginButton.layer.cornerRadius = 3.0
    }
}
