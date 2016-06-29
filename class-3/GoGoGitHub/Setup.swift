//
//  Setup.swift
//  GoGoGitHub
//
//  Created by Sean Champagne on 6/28/16.
//  Copyright © 2016 Sean Champagne. All rights reserved.
//

import UIKit


protocol Setup
{
    static var id: String { get }
    
    func setup()
    func setupAppearance()
}

extension Setup //where Self: UIViewController
{
    static var id: String{
        return String(self)
    }
}