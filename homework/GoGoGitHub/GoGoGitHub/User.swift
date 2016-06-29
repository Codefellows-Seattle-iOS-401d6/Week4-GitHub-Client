//
//  User.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/29/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let login: String

    let location: String?
    let blog: String?
//    let createdAt: NSDate
    let followers: Int
    let avatarUrl: String?
    
    init?(json: [String : AnyObject]) {
        if let name = json["name"] as? String, login = json["login"] as? String, followers = json["followers"] as? Int {
            self.name = name
            self.login = login
            self.followers = followers
            
            self.avatarUrl = json["avatar_url"] as? String
            self.location = json["location"] as? String
            self.blog = json["blog"] as? String
            
        } else {
            return nil
        }
    }
}