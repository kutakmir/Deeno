//
//  MessagesTableViewCell.swift
//  Deeno
//
//  Created by Michal Severín on 03.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class MessagesTableViewCell: AbstractTableViewCell<MessagesTableViewCellView> {

    var inset: UIEdgeInsets? {
        didSet {
            guard let inset = inset else {
                return
            }
            cellInsets = inset
        }
    }
    
    // MARK: - Initialization
    override func initializeElements() {
        super.initializeElements()
        
        content.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        content.clipsToBounds = true
        content.backgroundColor = Palette[.white]
    }
}

class MessagesTableViewCellView: View {
    
    // MARK: - Properties
    // MARK: - Public Properties
    var message: String? {
        get {
            return messageLabel.text
        }
        set {
            messageLabel.text = newValue
        }
    }

    
    // MARK: - Fileprivate Properties
    let messageLabel = Label()

    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()

        messageLabel.font = SystemFont[.description]
        messageLabel.textColor = Palette[.gray]
        messageLabel.numberOfLines = 0
    }
    
    internal override func addElements() {
        super.addElements()
        
        addSubviews(views:
            [
                messageLabel,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(5)
            make.top.equalTo(self)
            make.bottom.equalTo(self)
        }
    }
}
