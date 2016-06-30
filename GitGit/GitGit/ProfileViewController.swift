//
//  ProfileViewController.swift
//  GitGit
//
//  Created by Derek Graham on 6/29/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class
{
    func profileViewControllerDidFinish()
}

class ProfileViewController: UIViewController, Setup
{
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var profileLocation: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupAppearance()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup()
    {
        API.shared.GETUser { (user) in
            if let user = user {
                self.profileName.text = user.name
                self.profileLocation.text = user.location
                
//                let url = NSURL(string: (user.avatarURL)!)
//                let data = NSData(contentsOfURL: user.avatarURL!) //make sure your image in this url does exist, otherwise unwrap in a if let check
                self.profileImage.image = UIImage(data: NSData(contentsOfURL: user.avatarURL!)!)
            }
        }
    }
    
    func setupAppearance() {
        self.closeButton.layer.cornerRadius = 3.0
    }
    
    

    @IBAction func closeButtonAction(sender: UIButton){
        
        self.delegate?.profileViewControllerDidFinish()
    }
    

}

