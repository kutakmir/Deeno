//
//  TextField.swift
//  Deeno
//
//  Created by Michal Severín on 29.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class TextField: UITextField {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        initialize()
    }
}
