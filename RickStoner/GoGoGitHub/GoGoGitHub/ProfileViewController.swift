//
//  ProfileViewController.swift
//  GoGoGitHub
//
//  Created by Rick  on 6/29/16.
//  Copyright © 2016 Rick . All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    func profileViewControllerDidFinsish()
}

class ProfileViewController: UIViewController, Setup {

    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var closeLabel: UIButton!
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        //
    }
    
    func setupAppearance() {
        self.closeLabel.layer.cornerRadius = 3.0
    }
    
    @IBAction func closeButtonSelected(sender: AnyObject) {
        self.delegate?.profileViewControllerDidFinsish()
    }
    
}
