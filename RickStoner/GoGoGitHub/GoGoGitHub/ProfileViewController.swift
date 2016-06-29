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
    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupAppearance()

   
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        API.shared.GETUser { (user) in
            if let user = user {
                self.nameLabel.text = user.name
                self.locationLabel.text = user.location
                guard let image = NSURL(string: user.imageURL!) else { return }
                guard let imgData = NSData(contentsOfURL: image) else { return }
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.profileImage.layer.cornerRadius = 15.0
                    self.profileImage.image = UIImage(data: imgData)
                })
            }
       

        }
    }
    
    func setupAppearance() {
        self.closeLabel.layer.cornerRadius = 3.0
        self.profileImage.layer.cornerRadius = 10.0
    }
    
    @IBAction func closeButtonSelected(sender: AnyObject) {
        self.delegate?.profileViewControllerDidFinsish()
    }
    
}
