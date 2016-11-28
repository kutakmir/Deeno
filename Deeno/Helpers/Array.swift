//
//  Array.swift
//  Deeno
//
//  Created by Michal Severín on 28.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

extension Array {

    subscript(safe safe: Int) -> Element? {
        if safe < count, count > 0 {
            return self[safe]
        }
        return nil
    }
}
