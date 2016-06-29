//
//  ProfileViewController.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/29/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import UIKit


protocol ProfileViewControllerDelegate: class {
    
    func profileViewControllerDidFinish()
}


class ProfileViewController: UIViewController, Setup {

    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.setup()
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Setup
    
    func setup() {
        //
        
        API.shared.GETuser { (user) in
            if let user = user {
                self.nameLabel.text = user.name
                self.locationLabel.text = user.location 
            }
            
        }
    }
    
    func setupAppearance() {
      //
        self.closeButton.layer.cornerRadius = 3.0
    }
    
    @IBAction func closeButtonSelected(sender: UIButton) {
        //
        self.delegate?.profileViewControllerDidFinish()
    }

}
