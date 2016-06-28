//
//  Additions.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/28/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import Foundation
extension NSDate
{
    class func dateFromString(string: String) -> NSDate {
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return formatter.dateFromString(string)!
    }
}