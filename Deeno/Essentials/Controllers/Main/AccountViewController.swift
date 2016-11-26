//
//  AccountViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import UIKit

class AccountViewController: AbstractViewController {

    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }

    internal override func addElements() {
        super.addElements()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
    }

    internal override func initializeElements() {
        super.initializeElements()
    }

    // MARK: - User actions
    func logoutButtonTapped() {
        logout()
    }

    // MARK: - Actions
    fileprivate func logout() {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.window?.rootViewController = LoginViewController()
        }
    }
}
