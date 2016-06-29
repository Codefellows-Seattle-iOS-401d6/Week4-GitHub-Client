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
    //    let createdAt: NSDate
    
    init?(json: [String:AnyObject]) {
        if let name = json["name"] as? String {
            self.name = name
        } else {
            return nil
        }
    }
}


extension NSDate {
    class func formattedDate(date: String) -> NSDate? {
        let formatter = NSDateFormatter()
        formatter.dateStyle = NSDateFormatterStyle.NoStyle
        formatter.locale = NSLocale.autoupdatingCurrentLocale()
        formatter.dateFormat = "dd-MM-yyyy"
        if let dateAsString = formatter.dateFromString(date) {
            return dateAsString
        } else {
            return nil
        }
    }
}

