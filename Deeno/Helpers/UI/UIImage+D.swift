//
//  UIImage.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

/// Public propertie for UIImage.
public var Asset = UIImage()

/**
 This extension contains all used applications images.
 */
extension UIImage {

    // MARK: Enum definition
    /**
     Asset is an parent enum for other enums with cases of localized strings.
     */
    internal enum Assets {

        enum Main {
        }
    }

    subscript(main: Assets.Main) -> UIImage {
        return UIImage()
    }
}
