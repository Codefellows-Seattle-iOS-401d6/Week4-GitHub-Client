//
//  Owner.swift
//  GitGit
//
//  Created by Derek Graham on 6/28/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import Foundation

struct Owner
{
    let login: String
    let id: Int
    let url: String
    
    
    init?(json: [String : AnyObject])
    {
        if let login = json["login"] as? String, avatarURL
        
    }
    
}