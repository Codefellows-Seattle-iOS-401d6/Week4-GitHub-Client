//
//  User.swift
//  GoGoGitHub
//
//  Created by Jess Malesh on 6/29/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import UIKit
//add profilimage url

struct User
{
    let name: String
    let login: String
    let location: String?
    let blog: String?
    let createdAt: NSDate
    let followers: Int
    let profileImage: String?
    
    init?(json: [String: AnyObject])
    {
        if let name = json["name"] as? String, login = json["login"] as? String, followers = json["followers"] as? Int {
            let createdAt = NSDate.dataFromString(json["created_at"] as! String)
            let location = json["location"] as? String
            let blog = json["blog"] as? String
            let profileImage = json["avatar_url"] as! String
            
            self.name = name
            self.login = login
            self.location = location
            self.blog = blog
            self.createdAt = createdAt
            self.followers = followers
            self.profileImage = profileImage
        
    } else {
        return nil
        }
    }
    
}