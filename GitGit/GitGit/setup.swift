//
//  setup.swift
//  GitGit
//
//  Created by Derek Graham on 6/28/16.
//  Copyright © 2016 Derek Graham. All rights reserved.
//

import UIKit

protocol Setup
{
    
    static var id: String { get }
    func setup()
    func setupAppearance()
    
}

extension Setup // where Self: UIViewController
{
    static var id: String {
        return String(self)
    }
}