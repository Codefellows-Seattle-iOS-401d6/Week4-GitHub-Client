//
//  User.swift
//  GoGoGitHub
//
//  Created by Rick  on 6/29/16.
//  Copyright © 2016 Rick . All rights reserved.
//

import Foundation

class User {
    
    let name: String
    let login: String
    let location: String?
    let blog: String?
    let createdAt: NSDate
    let followers: Int
    let imageURL: String?
    
    
    init?(json: [String : AnyObject]) {
        if let name = json["name"] as? String, login = json["login"] as? String, followers = json["followers"] as? Int {
            let createdAt = NSDate.dateFromString(json["created_at"] as! String)
            let location = json["location"] as? String
            let imageURL = json["avatar_url"] as? String
            let blog = json["blog"] as? String
            
            self.name = name
            self.login = login
            self.location = location
            self.blog = blog
            self.createdAt = createdAt
            self.followers = followers
            self.imageURL = imageURL
            
        }
            
        else {
                return nil
        }
    }
}