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
    fileprivate let logoImageView = ImageView()
    
    fileprivate let userNameTextField = UITextField()
    fileprivate let passwordTextField = UITextField()

    fileprivate let registerButton = Button(type: .system)
    fileprivate let closeButton = Button(type: .system)

    // MARK: - Initialization
    internal override func initializeElements() {
        super.initializeElements()

        closeButton.setTitle("X", for: .normal)
        closeButton.tintColor = Palette[.white]
        closeButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)

        logoImageView.image = #imageLiteral(resourceName: "logo vertical")
        logoImageView.contentMode = .scaleAspectFit

        userNameTextField.placeholder = "email"
        userNameTextField.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        userNameTextField.backgroundColor = Palette[.white]
        userNameTextField.layer.borderColor = Palette[.gray].cgColor
        userNameTextField.layer.borderWidth = 0.3
        userNameTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 35))
        userNameTextField.leftViewMode = .always
        
        passwordTextField.placeholder = "password"
        passwordTextField.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = Palette[.white]
        passwordTextField.layer.borderColor = Palette[.gray].cgColor
        passwordTextField.layer.borderWidth = 0.3
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 35))
        passwordTextField.leftViewMode = .always

        registerButton.setTitle("Sign up", for: .normal)
        registerButton.backgroundColor = Palette[.primary]
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        registerButton.tintColor = Palette[.white]
        registerButton.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
    }

    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                closeButton,
                userNameTextField,
                passwordTextField,
                registerButton,
                logoImageView,
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
        
        closeButton.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(-20)
            make.top.equalTo(view).inset(20)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }

        userNameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(view).inset(-30)
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

        registerButton.snp.makeConstraints { make in
            make.centerY.equalTo(passwordTextField.snp.bottom).offset(20)
            make.leading.equalTo(view).inset(50)
            make.trailing.equalTo(view).inset(50)
        }
    }

    internal override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.primary]
    }

    // MARK: - Actions
    fileprivate func register() {
        guard let email = userNameTextField.text, let password = passwordTextField.text else { return }
        FIRAuth.auth()?.createUser(withEmail: email, password: password) { user, error in
            if let error = error {
                print(error.localizedDescription)
                return
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
