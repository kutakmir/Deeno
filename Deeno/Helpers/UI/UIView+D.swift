//
//  UIView+AM.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

extension UIView: Initializable {

    /**
     Add views as subview to view.
     - Parameter views: represents all views
     - Example view.addSubviews([label, button])
     */
    func addSubviews(views: [UIView]) {
        views.forEach { element in
            addSubview(element)
        }
    }

    // MARK: - <Initializable>
    func addElements() {}
    func customInit() {}
    func initializeElements() {}
    func setupConstraints() {}
    func loadData() {}
    func setupView() {}
}

class View: UIView {
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        addElementsAndApplyConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addElementsAndApplyConstraints()
    }
}
