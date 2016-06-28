//
//  Setup.swift
//  GoGoGithub
//
//  Created by hannah gaskins on 6/28/16.
//  Copyright © 2016 hannah gaskins. All rights reserved.
//

import Foundation

protocol Setup {
    
    static var id: String { get }
    
    func setup()
    func setupAppearance()
    
}

extension Setup {
    static var id: String {
        return String(self)
    }
}

