//
//  ViewController.swift
//  GitGit
//
//  Created by Derek Graham on 6/27/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
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

    @IBAction func loginButtonSelected(sender: AnyObject) {
    
        
//        do {
//            let token = try GitHubOAuth.shared.accessToken()
//            print("we have a saved token\(token)")
//        } catch let error {
//            print("no token saved, trying to get\(error)")
              GitHubOAuth.shared.OAuthRequestWith(["scope": "email,user,repo"])
//        }
        
      
    }

//    @IBAction func displayToken(sender: AnyObject) {
//        do {
//            let token = try GitHubOAuth.shared.accessToken()
//            print(token)
//        } catch let error {
//            print(error)
//        }
//    }
}
// MARK: Setup

extension ViewController: Setup {
    
    func setup() {
        self.title = "Repositories"
    }
    
    func setupAppearance() {
        self.loginButton.layer.cornerRadius = 3.0
    }

}




