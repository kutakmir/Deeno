//
//  CollectionViewCell+AM.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

// MARK: - UICollectionViewCell
extension UICollectionViewCell: Reusable {

    /// Cell identifier by cell class name.
    static var identifier: String {
        return NSStringFromClass(classForCoder())
    }
}
