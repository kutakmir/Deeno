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
    
    var alignment: NSTextAlignment? {
        get {
            return messageLabel.textAlignment
        }
        set {
            guard let newValue = newValue else {
                return
            }
            messageLabel.textAlignment = newValue
            createdLabel.textAlignment = newValue
        }
    }
    
    var textColor: UIColor = Palette[.white] {
        didSet {
            messageLabel.textColor = textColor
            createdLabel.textColor = textColor
        }
    }
    
    var createdTime: String? {
        get {
            return createdLabel.text
        }
        set {
            createdLabel.text = newValue
        }
    }
    
    // MARK: - Fileprivate Properties
    fileprivate let messageLabel = Label()
    fileprivate let createdLabel = Label()
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()

        createdLabel.font = SystemFont[.small]
        
        messageLabel.font = SystemFont[.description]
        messageLabel.textColor = Palette[.gray]
        messageLabel.numberOfLines = 0
    }
    
    internal override func addElements() {
        super.addElements()
        
        addSubviews(views:
            [
                messageLabel,
                createdLabel,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()

        createdLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(5)
            make.bottom.equalTo(self)
            make.height.equalTo(20)
            make.top.equalTo(messageLabel.snp.bottom).offset(5)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.trailing.equalTo(self).inset(5)
            make.top.equalTo(self).inset(5)
        }
    }
}
