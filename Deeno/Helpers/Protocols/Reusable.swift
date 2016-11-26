//
//  Reusable.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

/**
 Reusable Protocol.
 */
internal protocol Reusable {

    /// Identifier for view recycling.
    static var identifier: String {get}
}
