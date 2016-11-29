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

    fileprivate let userNameTextField = TextField()
    fileprivate let passwordTextField = TextField()
    
    fileprivate let logoImageView = ImageView()

    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()

        userNameTextField.placeholder = "email"
        userNameTextField.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
        userNameTextField.backgroundColor = Palette[.white]
        userNameTextField.layer.borderColor = Palette[.gray].cgColor
        userNameTextField.layer.borderWidth = 0.3
        userNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 35))
        userNameTextField.leftViewMode = .always
        
        passwordTextField.placeholder = "password"
        passwordTextField.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = Palette[.white]
        passwordTextField.layer.borderColor = Palette[.gray].cgColor
        passwordTextField.layer.borderWidth = 0.3
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 35))
        passwordTextField.leftViewMode = .always
        
        logoImageView.image = #imageLiteral(resourceName: "logo")
        logoImageView.contentMode = .scaleAspectFit
        
        loginButton.setTitle("Sign in", for: .normal)
        loginButton.backgroundColor = Palette[.primary]
        loginButton.tintColor = Palette[.white]
        loginButton.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = Palette[.primary]
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.tintColor = Palette[.white]
        registerButton.layer.cornerRadius = CGFloat(Configuration.GUI.ItemCornerRadius)
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                logoImageView,
                userNameTextField,
                passwordTextField,
                loginButton,
                registerButton,
            ]
        )
    }

    internal override func setupConstraints() {
        super.setupConstraints()

        logoImageView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalTo(userNameTextField.snp.top).offset(-20)
            make.width.equalTo(100)
            make.height.equalTo(100)
        }
        
        userNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view).inset(-20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
            make.height.equalTo(35)
        }

        passwordTextField.snp.makeConstraints { make in
            make.centerY.equalTo(userNameTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
            make.height.equalTo(35)
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
