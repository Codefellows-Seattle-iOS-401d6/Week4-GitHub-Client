//
//  Repository.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/28/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
struct Repository {
    let name: String
    //    let description: String?
    //    let owner : Owner?
    //    let url : String
    //    let language : String?
    //    let openIssues: Int
    //    let id: Int
    let createdAt: NSDate
    
    init?(json: [String:AnyObject]) {
        if let name = json["name"] as? String, let date = json["created_at"] as? String {
            self.name = name
            self.createdAt = NSDate.formattedDate(date)
        } else {
            return nil
        }
    }
}


extension NSDate {
    class func formattedDate(date: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return formatter.dateFromString(date)!
    }
}


