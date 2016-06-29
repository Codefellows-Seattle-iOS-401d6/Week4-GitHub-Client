//
//  ProfileViewController.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/29/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate: class {
    
    func profileViewControllerDidFinish()
}

class ProfileViewController: UIViewController, Setup {

    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
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
    
    //MARK: Setup
    
    func setup() {
        API.shared.GETUser { (user) in
            if let user = user {
                self.nameLabel.text = user.name
                self.locationLabel.text = user.location
                guard let imgPath = user.avatarUrl else { return }
                guard let imgUrl = NSURL(string: imgPath) else { return }
                guard let imgData = NSData(contentsOfURL: imgUrl) else { return }
                dispatch_async(dispatch_get_main_queue(), {
                    self.imageView.image = UIImage(data: imgData)
                })
            }
        }
        
    }
    
    func setupAppearance() {
        self.closeButton.layer.cornerRadius = 3.0
    }
    
    //MARK: Action
    
    @IBAction func closeButtonSelected(sender: UIButton) {
        self.delegate?.profileViewControllerDidFinish()
    }
}
