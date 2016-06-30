//
//  User.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/29/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import Foundation

struct User
{
    let name: String
    let login: String
    let location: String?
    let blog: String?
    let createdAt: NSDate
    let followers: Int
    let avatarURL: String?
    
    init?(json: [String : AnyObject])
    {
        if let name = json["name"] as? String, login = json["login"] as? String, followers = json["followers"] as? Int {
            let createdAt = NSDate.dateFromString(json["created_at"] as! String)
            let location = json["location"] as? String
            let blog = json["blog"] as? String
            let avatarURL = json["avatar_url"] as? String
            
            self.name = name
            self.login = login
            self.location = location
            self.blog = blog
            self.createdAt = createdAt
            self.followers = followers
            self.avatarURL = avatarURL
        }
            
        else {
            
            return nil
        }
    }

}