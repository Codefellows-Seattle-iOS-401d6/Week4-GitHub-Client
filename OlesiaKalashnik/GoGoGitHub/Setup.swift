//
//  Setup.swift
//  GoGoGitHub
//
//  Created by Olesia Kalashnik on 6/28/16.
//  Copyright © 2016 Olesia Kalashnik. All rights reserved.
//

import Foundation
protocol Setup {
    static var id: String {get}
    func setup()
    func setupAppearance()
}

extension Setup {
    static var id : String {
        return String(self)
    }
    
}