//
//  Owner.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/28/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
struct Owner {
    let login: String
    let avatarURL : String
    let id: Int
    let URL : String
    
    init?(json: [String:AnyObject]) {
        if let login = json["login"] as? String, let avatarURL = json["avatar_url"] as? String, let id = json["id"] as? Int, let URL = json["url"] as? String {
            self.login = login
            self.avatarURL = avatarURL
            self.id = id
            self.URL = URL
        
    } else {
        return nil
        }
    }
}