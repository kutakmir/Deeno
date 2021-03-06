//
//  Initialize.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

/**
 Initializable protocol get basic function for right initializa.
 - addElements
 - initializeElements
 - setupConstraints
 - customSetup
 - setupView
 */
protocol Initializable {

    /**
     Add all elements as subview to the main view
     */
    func addElements()

    /**
     Initialize font, color, properties etc.
     */
    func initializeElements()

    /**
     Setup constraint for each element
     */
    func setupConstraints()

    /**
     Setup anything you want
     */
    func customInit()

    /**
     Set backgroundColor, gesture, etc in the view
     */
    func setupView()

    /**
     Load data from API
     */
    func loadData()
}

extension Initializable {

    /**
     Initializable function contains all ordered initialzable methods from protocol.
     */
    func addElementsAndApplyConstraints() {
        defer {
            customInit()
            setupConstraints()
        }
        initializeElements()
        addElements()
        setupView()
    }

    func initialize() {
        initializeElements()
    }

    func loadData() {
        loadData()
    }
}
