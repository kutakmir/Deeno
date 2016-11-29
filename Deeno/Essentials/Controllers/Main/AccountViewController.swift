//
//  AccountViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import UIKit

class AccountViewController: AbstractViewController {

    // MARK: - Initialization
    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
        navigationItem.title = AccountSessionManager.manager.accountSession?.userInfo?.email
    }

    internal override func addElements() {
        super.addElements()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logoutButtonTapped))
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
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            AccountSessionManager.manager.closeSession()
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.window?.rootViewController = LoginViewController()
            }
        } catch let signOutError as NSError {
            print ("Error signing out: \(signOutError.localizedDescription)")
        }
    }
}
