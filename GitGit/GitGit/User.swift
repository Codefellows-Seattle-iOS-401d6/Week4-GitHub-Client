//
//  User.swift
//  GitGit
//
//  Created by Derek Graham on 6/29/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
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
    let avatarURL: NSURL?
    init?(json: [String : AnyObject])
    {
        if let name = json["name"] as? String, login = json["login"] as? String, followers = json["followers"] as? Int {
                self.name = name
                self.avatarURL = NSURL(string: json["avatar_url"] as! String) // NSURL(string: (user.avatarURL)!)
                self.login = login
                self.location = json["location"] as? String
                self.blog = json["blog"] as? String
            
                self.createdAt = NSDate.dateFromString(json["created_at"] as! String)
                self.followers = followers
            
        }
        else {
             return nil
        }

    }
}

/*
 
 ["followers_url": https://api.github.com/users/derekgraham/followers, "private_gists": 0, "received_events_url": https://api.github.com/users/derekgraham/received_events, "plan": {
 collaborators = 0;
 name = free;
 "private_repos" = 0;
 space = 976562499;
 }, "organizations_url": https://api.github.com/users/derekgraham/orgs, "total_private_repos": 0, "gravatar_id": , "disk_usage": 19521, "company": <null>, "email": <null>, "public_gists": 0, "html_url": https://github.com/derekgraham, "following_url": https://api.github.com/users/derekgraham/following{/other_user}, "collaborators": 0, "site_admin": 0, "public_repos": 24, "type": User, "starred_url": https://api.github.com/users/derekgraham/starred{/owner}{/repo}, "repos_url": https://api.github.com/users/derekgraham/repos, "avatar_url": https://avatars.githubusercontent.com/u/17793690?v=3, "url": https://api.github.com/users/derekgraham, "created_at": 2016-03-12T04:43:07Z, "gists_url": https://api.github.com/users/derekgraham/gists{/gist_id}, "subscriptions_url": https://api.github.com/users/derekgraham/subscriptions, "blog": www.derekgraham.com, "followers": 14, "hireable": <null>, "login": derekgraham, "location": <null>, "updated_at": 2016-06-29T17:32:55Z, "events_url": https://api.github.com/users/derekgraham/events{/privacy}, "bio": <null>, "name": Derek Graham, "id": 17793690, "owned_private_repos": 0, "following": 23]
 
 */
