//
//  User.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/29/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation

class User {
    let name: String
    let login : String
    let location: String?
    let profileImage : NSURL?
    
    init?(json: [String: AnyObject]) {
        if let name = json["name"] as? String, let login = json["login"] as? String, let location = json["location"] as? String, let profileImage = json["avatar_url"] as? String {
            
            self.name = name
            self.login = login
            self.location = location
            self.profileImage = NSURL(string: profileImage)
            return
        }
        return nil
    }
}