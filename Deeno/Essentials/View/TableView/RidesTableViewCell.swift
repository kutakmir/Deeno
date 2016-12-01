//
//  RidesTableViewCell.swift
//  Deeno
//
//  Created by Michal Severín on 29.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class RidesTableViewCell: AbstractTableViewCell<RidesTableViewCellView> {
    
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

class RidesTableViewCellView: View {
    
    // MARK: - Properties
    // MARK: - Public Properties
    var dayText: String? {
        get {
            return dayLabel.text
        }
        set {
            dayLabel.text = newValue
        }
    }
    var timeText: String? {
        get {
            return timeLabel.text
        }
        set {
            timeLabel.text = newValue
        }
    }
    var dateText: String? {
        get {
            return dateLabel.text
        }
        set {
            dateLabel.text = newValue
        }
    }
    var priceText: String? {
        get {
            return priceLabel.text
        }
        set {
            priceLabel.text = newValue
        }
    }
    var userImage: UIImage? {
        get {
            return userImageView.image
        }
        set {
            userImageView.image = newValue
        }
    }

    // MARK: - Fileprivate Properties
    fileprivate let dayLabel = Label()
    fileprivate let timeLabel = Label()
    fileprivate let dateLabel = Label()
    fileprivate let priceLabel = Label()
    
    fileprivate let userImageView = ImageView()
    
    fileprivate let footerView = View()
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
     
        dayLabel.font = SystemFont[.title]
        dayLabel.textColor = Palette[.gray]
        
        timeLabel.font = SystemFont[.description]
        timeLabel.textColor = Palette[.gray]
        
        dateLabel.font = SystemFont[.description]
        dateLabel.textColor = Palette[.lightBlue]
        
        priceLabel.font = SystemFont[.description]
        priceLabel.textColor = Palette[.white]
        priceLabel.font = SystemFont[.title]
        
        footerView.backgroundColor = Palette[.brown]
        
        userImageView.image = #imageLiteral(resourceName: "accPlaceholder")
        userImageView.contentMode = .scaleAspectFit
        userImageView.layer.cornerRadius = Configuration.GUI.UserImageCornerRadius
        userImageView.clipsToBounds = true
        userImageView.layer.borderColor = Palette[.white].cgColor
        userImageView.layer.borderWidth = Configuration.GUI.UserImageBorderWidth
    }
    
    internal override func addElements() {
        super.addElements()
        
        addSubviews(views:
            [
                footerView,
                dayLabel,
                timeLabel,
                dateLabel,
                priceLabel,
                userImageView,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        userImageView.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(40)
            make.width.equalTo(30)
            make.height.equalTo(30)
            make.bottom.equalTo(self)
        }
        
        footerView.snp.makeConstraints { make in
            make.leading.equalTo(self)
            make.trailing.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(30)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(self).inset(3)
            make.height.equalTo(20)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(dayLabel.snp.bottom)
            make.height.equalTo(18)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(timeLabel.snp.bottom)
            make.height.equalTo(18)
        }

        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(5)
            make.top.equalTo(dateLabel.snp.bottom).offset(9)
            make.bottom.equalTo(self).inset(1)
        }
    }
}
