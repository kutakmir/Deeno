//
//  RidesTableViewCell.swift
//  Deeno
//
//  Created by Michal Severín on 29.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class RidesTableViewCell: AbstractTableViewCell<RidesTableViewCellView> {
    
    override var cellInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 5)
    }
    
    // MARK: - Initialization
    override func initializeElements() {
        super.initializeElements()
        
        content.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
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

    // MARK: - Fileprivate Properties
    fileprivate let dayLabel = Label()
    fileprivate let timeLabel = Label()
    fileprivate let dateLabel = Label()
    fileprivate let priceLabel = Label()
    
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
        priceLabel.textColor = Palette[.black]
    }
    
    internal override func addElements() {
        super.addElements()
        
        addSubviews(views:
            [
                dayLabel,
                timeLabel,
                dateLabel,
                priceLabel,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        dayLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(self).inset(5)
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(dayLabel.snp.bottom).offset(5)
            make.height.equalTo(30)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.leading.equalTo(self).inset(5)
            make.top.equalTo(timeLabel.snp.bottom).offset(5)
            make.height.equalTo(20)
        }

        priceLabel.snp.makeConstraints { make in
            make.trailing.equalTo(self).inset(5)
            make.top.equalTo(dateLabel.snp.bottom).offset(5)
            make.bottom.equalTo(self).inset(5)
        }
    }
}
