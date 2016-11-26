//
//  UIFont.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/// Public propertie for UIFont.
public var SystemFont = UIFont()

/**
 This extension contains all used applications fonts.
 */
extension UIFont {

    // MARK: Enum definition
    internal enum Fonts {
        case title
        case description
    }

    subscript(font: Fonts) -> UIFont {
        switch font {
        case .title:
            return UIFont.systemFont(ofSize: 15)
        case .description:
            return UIFont.systemFont(ofSize: 11)
        }
    }
}
