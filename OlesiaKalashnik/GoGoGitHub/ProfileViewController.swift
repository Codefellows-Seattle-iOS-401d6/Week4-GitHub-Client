//
//  ProfileViewController.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/29/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    func profileVCDidFinish()
}

class ProfileViewController: UIViewController, Setup {
    
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate : ProfileViewControllerDelegate?
    var profileImage : UIImage?
    
    var user : User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAppearance()
    }
    
    @IBAction func closeProfile(sender: UIButton) {
        delegate?.profileVCDidFinish()
    }
    
    func setupAppearance() {
        self.closeButton.layer.cornerRadius = 3.0
    }
    
    func setup() {
        API.shared.GETUser { (user) in
            self.user = user
            self.nameLabel.text = user?.name
            self.locationLabel.text = user?.location
            self.loginLabel.text = user?.login
            
            guard let image = self.profileImage else {
                
                let qos = Int(QOS_CLASS_USER_INITIATED.rawValue)
                let nonMainQueue = dispatch_get_global_queue(qos, 0)
                dispatch_async(nonMainQueue) { () -> Void in
                    if let url = user?.profileImage {
                        if let data = NSData(contentsOfURL: url) {
                            dispatch_async(dispatch_get_main_queue())  { () -> Void in
                                self.profileImage = UIImage(data: data)
                                self.imageView.image = self.profileImage
                            }
                        }
                    }
                }
                return
            }
            self.imageView.image = image
        }
        
    }
    
}
