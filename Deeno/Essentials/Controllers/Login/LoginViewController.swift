//
//  LoginViewController.swift
//  Deeno
//
//  Created by Michal Severín on 22.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import DigitsKit
import Firebase
import SnapKit
import UIKit

class LoginViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: > private/internal
    fileprivate let loginButton = Button(type: .system)
    fileprivate let registerButton = Button(type: .system)

    fileprivate let userNameTextField = UITextField()
    fileprivate let passwordTextField = UITextField()

    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()

        userNameTextField.placeholder = "email"
        passwordTextField.placeholder = "password"
        passwordTextField.isSecureTextEntry = true

        loginButton.setTitle("Sign in", for: .normal)
        loginButton.backgroundColor = Palette[.lightBlue]
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        loginButton.tintColor = Palette[.white]

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = Palette[.lightBlue]
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.tintColor = Palette[.white]
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                userNameTextField,
                passwordTextField,
                loginButton,
                registerButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        userNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view).inset(-20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userNameTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }

        loginButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }

        registerButton.snp.makeConstraints { make in
            make.centerY.equalTo(loginButton.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }

    // MARK: - Actions
    fileprivate func login() {
        guard let email = self.userNameTextField.text, let password = self.passwordTextField.text else {
            return
        }
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { user, error in
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
    fileprivate func register() {
        let vc = RegisterViewController()
        present(vc, animated: true, completion: nil)
    }

    // MARK: - User Actions
    func loginButtonTapped() {
        login()
    }

    func registerButtonTapped() {
        register()
    }
}
