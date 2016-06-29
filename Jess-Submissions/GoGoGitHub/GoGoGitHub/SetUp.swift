//
//  SetUp.swift
//  GoGoGitHub
//
//  Created by Jess Malesh on 6/28/16.
//  Copyright © 2016 Jess Malesh. All rights reserved.
//

import UIKit

protocol Setup
{
    static var id: String { get }
    
    func setup()
    func setupAppearance()
    
}

extension Setup
{
    static var id: String {
        return String(self)
    }
}