//
//  Additions.swift
//  GoGoGitHub
//
//  Created by Jessica Malesh on 6/28/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import Foundation

extension NSDate {
    class func dataFromString(string: String) -> NSDate
    {
        
        let formatter = NSDateFormatter()
        formatter.locale = NSLocale.currentLocale()
        formatter.timeStyle = NSDateFormatterStyle.NoStyle
        formatter.dateFormat =  "yyyy-MM-dd'T'HH:mm:ss'Z'"
        
        return formatter.dateFromString(string)!
    }
}