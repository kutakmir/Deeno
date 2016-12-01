//
//  AccountViewController.swift
//  Deeno
//
//  Created by Michal Severín on 23.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Kingfisher
import Firebase
import UIKit

class AccountViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: Public Properties
    var userInfo: UserInfo? {
        didSet {
            guard let userInfo = userInfo else {
                return
            }
            if let profileUrl = userInfo.photoURL {
                profileImageView.kf.setImage(with: ImageResource(downloadURL: profileUrl), placeholder: #imageLiteral(resourceName: "accPlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            else {
                profileImageView.image = #imageLiteral(resourceName: "accPlaceholder")
            }
            navigationItem.title = AccountSessionManager.manager.accountSession?.userInfo?.displayName
            if let displayName = userInfo.displayName, !displayName.isEmpty {
                userNameTextField.text = displayName
            }
            else {
                userNameTextField.text = "edit your name"
            }
            emailTextField.text = userInfo.email
        }
    }

    // MARK: Private Properties
    fileprivate let profileImageView = ImageView()
    fileprivate let coverView = View()
    
    fileprivate let userNameTextField = UITextField()
    fileprivate let emailTextField = UITextField()
    
    fileprivate let emailLabel = Label()
    fileprivate let usernameLabel = Label()
    
    fileprivate let usernameTextfieldLaftView = View(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    fileprivate let emailTextfieldLaftView = View(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.lightBlue]))
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.primary]))
    }
    
    // MARK: - Initialization
    internal override func initializeElements() {
        super.initializeElements()
        
        userNameTextField.isEnabled = false
        userNameTextField.leftView = usernameTextfieldLaftView
        userNameTextField.leftViewMode = .always
        userNameTextField.textColor = Palette[.gray]

        emailTextField.isEnabled = false
        emailTextField.leftView = emailTextfieldLaftView
        emailTextField.leftViewMode = .always
        emailTextField.textColor = Palette[.gray]
        
        coverView.backgroundColor = Palette[.lightBlue]
        
        profileImageView.contentMode = .scaleAspectFit
        profileImageView.layer.cornerRadius = Configuration.GUI.UserImageCornerRadiusAccount
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = Palette[.white].cgColor
        profileImageView.layer.borderWidth = Configuration.GUI.UserImageBorderWidth
        
        emailLabel.text = "Email:"
        
        usernameLabel.text = "Name:"
    }

    internal override func addElements() {
        super.addElements()
        
        usernameTextfieldLaftView.addSubview(usernameLabel)
        emailTextfieldLaftView.addSubview(emailLabel)
        view.addSubviews(views:
            [
                coverView,
                profileImageView,
//                userNameTextField,
                emailTextField,
            ]
        )
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonTapped))
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        emailLabel.snp.makeConstraints { make in
            make.centerY.equalTo(emailTextfieldLaftView)
            make.leading.equalTo(emailTextfieldLaftView)
            make.trailing.equalTo(emailTextfieldLaftView)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(usernameTextfieldLaftView)
            make.leading.equalTo(usernameTextfieldLaftView)
            make.trailing.equalTo(usernameTextfieldLaftView)
        }
        
        coverView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(10)
            make.centerX.equalTo(view)
            make.width.equalTo(80)
            make.height.equalTo(80)
        }
        
//        userNameTextField.snp.makeConstraints { make in
//            make.top.equalTo(profileImageView.snp.bottom).offset(15)
//            make.leading.equalTo(view).inset(10)
//            make.trailing.equalTo(view).inset(10)
//            make.height.equalTo(0)
//        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(view).inset(10)
            make.height.equalTo(30)
        }
    }
    
    override func setupView() {
        super.setupView()

        view.backgroundColor = Palette[.white]
    }

    internal override func customInit() {
        super.customInit()

        userInfo = AccountSessionManager.manager.accountSession?.userInfo
    }

    // MARK: - User actions
    func logoutButtonTapped() {
        logout()
    }
    
    func editButtonTapped() {
        editAccountInfo()
    }
    
    func cancelEditButtonTapped() {
        cancelEditAccountInfo()
    }

    // MARK: - Actions
    fileprivate func editAccountInfo() {
        userNameTextField.isEnabled = true
        emailTextField.isEnabled = true
        userNameTextField.textColor = Palette[.black]
        emailTextField.textColor = Palette[.black]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(cancelEditButtonTapped))
    }
    
    fileprivate func cancelEditAccountInfo() {
        var user = UserInfo.load()
        if let email = emailTextField.text, email != userInfo?.email {
            if let currentUser = FIRAuth.auth()?.currentUser {
                currentUser.updateEmail(email, completion: { error in
                    if error == nil {
                        user?.email = email
                        user?.displayName = self.userNameTextField.text ?? String.empty
                        user?.save()
                        AccountSessionManager.manager.accountSession?.userInfo = user
                        self.userInfo = user
                        self.userNameTextField.isEnabled = false
                        self.emailTextField.isEnabled = false
                        self.userNameTextField.textColor = Palette[.gray]
                        self.emailTextField.textColor = Palette[.gray]
                        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonTapped))
                    }
                    else {
                        print(error?.localizedDescription)
                    }
                })
            }
        }
        else {
            self.userNameTextField.isEnabled = false
            self.emailTextField.isEnabled = false
            self.userNameTextField.textColor = Palette[.gray]
            self.emailTextField.textColor = Palette[.gray]
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.editButtonTapped))
        }
    }

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
