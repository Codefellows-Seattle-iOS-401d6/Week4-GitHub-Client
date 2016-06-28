//
//  Setup.swift
//  GoGoGitHub
//
//  Created by Sung Kim on 6/28/16.
//  Copyright © 2016 Sung Kim. All rights reserved.
//

import UIKit

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