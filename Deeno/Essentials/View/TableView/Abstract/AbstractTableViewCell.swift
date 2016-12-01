//
//  AbstractTableViewCell.swift
//  Deeno
//
//  Created by Michal Severín on 29.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class AbstractTableViewCell<ContentView: View>: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        addElementsAndApplyConstraints()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addElementsAndApplyConstraints()
    }
    
    // MARK: - Properties
    // MARK: Public/Internal Properties
    lazy var content: ContentView = ContentView()
    var cellInsets: UIEdgeInsets = .zero {
        didSet {
            content.snp.remakeConstraints { make in
                make.edges.equalTo(self).inset(cellInsets)
            }
            self.layoutIfNeeded()
        }
    }
    
    // MARK: - Initialization
    override func initializeElements() {
        super.initializeElements()
        
        content.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        backgroundColor = UIColor.Palette.clear.color
    }
    
    override func addElements() {
        super.addElements()
        
        addSubview(content)
    }
    
    override func setupConstraints() {
        super.setupConstraints()
        
        content.snp.makeConstraints { make in
            make.edges.equalTo(self).inset(cellInsets)
        }
    }
}
