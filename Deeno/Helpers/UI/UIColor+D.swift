//
//  UIColor+AM.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation
import UIKit

/**
 Palette protocol.
 */
private protocol PaletteProtocol {
    var color: UIColor { get }
}

/// Public propertie for UIColor.
public var Palette = UIColor()

/**
 This extension contains all used applications color.
 */
extension UIColor {

    // MARK: Enum definition
    /**
     Palette contains all user color in this app.
     - black
     - brown
     - clear
     - gray
     - lightBlue
     - lightGray
     - primary
     - tabBar
     -white
     */
    internal enum Palette: PaletteProtocol {

        case black
        case brown
        case clear
        case gray
        case lightBlue
        case lightGray
        case primary
        case tabBar
        case white

        var color: UIColor {
            switch self {
            case .clear:
                return UIColor.clear
            case .black:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            case .brown:
                return #colorLiteral(red: 0.8156862745, green: 0.6745098039, blue: 0.4549019608, alpha: 1)
            case .gray:
                return #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            case .lightBlue:
                return #colorLiteral(red: 0.4899612069, green: 0.5155428052, blue: 1, alpha: 1)
            case .lightGray:
                return #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            case .primary:
                return #colorLiteral(red: 0.5137254902, green: 0.7137254902, blue: 0.5803921569, alpha: 1)
            case .tabBar:
                return #colorLiteral(red: 0.9028286934, green: 0.9497063756, blue: 0.9135240912, alpha: 1)
            case .white:
                return #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            }
        }
    }

    subscript(palette: Palette) -> UIColor {
        return palette.color
    }

    public convenience init(rgba: UInt32) {
        self.init(
            red: CGFloat((rgba & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgba & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgba & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
