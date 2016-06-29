//
//  ProfileViewController.swift
//  GoGoGitHub
//
//  Created by Jessica Malesh on 6/29/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class
{
    func profileViewControllerDidFinish()
}

class ProfileViewController: UIViewController, Setup
{

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    
    weak var delegate: ProfileViewControllerDelegate?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.setup()
        self.setupAppearance()
      
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        
    }
    
    func setup()
    {
        API.shared.GETUser { (user) in
            if let user = user {
                self.nameLabel.text = user.name
                self.locationLabel.text = user.location
                
                guard let imgPath = user.profileImage else { return }
                guard let imgUrl = NSURL(string: imgPath) else { return }
                guard let imgData = NSData(contentsOfURL: imgUrl) else { return }
                    dispatch_async(dispatch_get_main_queue(), {
                        self.profileImage.image = UIImage(data: imgData)
                })
            }
        }
    }
    
    func setupAppearance()
    {
        self.closeButton.layer.cornerRadius = 3.0
    }

    @IBAction func closeButtonSelected(sender: UIButton)
    {
        self.delegate?.profileViewControllerDidFinish()
    }
    
    

    
    
}





























