//
//  RegisterViewController.swift
//  Deeno
//
//  Created by Michal Severín on 26.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import SnapKit
import Firebase
import FirebaseAuthUI
import FirebaseAuth
import UIKit

class RegisterViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: - Private Properties
    fileprivate let userNameTextField = UITextField()
    fileprivate let passwordTextField = UITextField()

    fileprivate let registerButton = Button(type: .system)
    fileprivate let closeButton = Button(type: .system)

    // MARK: - Initialization
    internal override func initializeElements() {
        super.initializeElements()

        closeButton.setTitle("Close", for: .normal)
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        userNameTextField.placeholder = "email"
        passwordTextField.placeholder = "password"
        passwordTextField.isSecureTextEntry = true

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = Palette[.lightBlue]
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.tintColor = Palette[.white]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                closeButton,
                userNameTextField,
                passwordTextField,
                registerButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(0)
            make.top.equalTo(view).inset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        userNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view).inset(-30)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userNameTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }

        registerButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }

    // MARK: - Actions
    fileprivate func register() {
        guard let email = userNameTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            if let user = user {
                AccountSessionManager.manager.accountSession = AccountSession(user: user)
                if let window = (UIApplication.shared.delegate as? AppDelegate)?.window {
                    window.rootViewController = TabBarController()
                }
            }
        }
    }

    // MARK: - User Actions
    func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    func registerButtonTapped() {
        register()
    }
}
