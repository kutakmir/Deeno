//
//  Extensions.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

extension UICollectionView {

    /**
     Returns a reusable cell object located by its identifier.
     - Parameter indexPath: The index path specifying the location of the cell. The data source receives this information when it is asked for the cell and should just pass it along. This method uses the index path to perform additional configuration based on the cell’s position in the collection view.
     - Returns: A valid cell object.
     */
    func dequeueCell<Cell: UICollectionViewCell>(indexPath: IndexPath) -> Cell where Cell: Reusable {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: Cell.identifier, for: indexPath as IndexPath) as? Cell else {
            fatalError("Unable to dequeue cell \(Cell.identifier)")
        }
        return cell
    }

    /**
     Register cell with identifier from a class name.
     - Parameter cell: A custom cell to be used for collectionView.
     */
    func register<Cell: UICollectionViewCell>(cell: Cell.Type) where Cell: Reusable {
        self.register(cell.self, forCellWithReuseIdentifier: cell.identifier)
    }
}
