//
//  RidesViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase

import UIKit

class RidesViewController: AbstractViewController {

    internal override func loadData() {
        super.loadData()

        let ref = FIRDatabase.database().reference(withPath: "messages")

        ref.observe(.value, with: { snapshot in

            print(snapshot.value)

        })

    }

    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }
}
