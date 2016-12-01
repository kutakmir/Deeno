//
//  RideDetailViewController.swift
//  Deeno
//
//  Created by Michal Severín on 30.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import UIKit

class RideDetailViewController: AbstractViewController {
    // MARK: - Properties
    // MARK: Public Properties
    var ride: Rides? {
        didSet {
            guard let ride = ride else {
                return
            }
            rideDay.text = TimeFormatsEnum.dateTime.dateFromString(ride.date)?.day
            rideDate.text = ride.date
            ridePrice.text = "\(ride.price ?? String.empty) $"
            ridePickup.text = "Pickup in: \(ride.departure ?? String.empty)"
            usernameLabel.text = ride.username
        }
    }
    
    // MARK: Private Properties
    fileprivate let profileImageView = ImageView()
    fileprivate let coverView = View()
    
    fileprivate let messageImageView = ImageView(image: #imageLiteral(resourceName: "messages"))
    fileprivate let phoneImageView = ImageView(image: #imageLiteral(resourceName: "phone"))
    
    fileprivate let usernameLabel = Label()
    fileprivate let rideDate = Label()
    fileprivate let rideDay = Label()
    fileprivate let ridePrice = Label()
    fileprivate let ridePickup = Label()
    fileprivate let pitchLabel = Label()
    
    fileprivate let alertController = UIAlertController(title: "Message", message: nil, preferredStyle: .alert)
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        
//        navigationController?.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.lightBlue]))
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        
//        navigationController?.navigationBar.applyStyle(style: .solid(withStatusBarColor: Palette[.primary]))
//    }
//    
    // MARK: - Initialization
    internal override func initializeElements() {
        super.initializeElements()
        
        messageImageView.contentMode = .scaleAspectFit
        messageImageView.isUserInteractionEnabled = true
        messageImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(createMessage)))
        
        phoneImageView.contentMode = .scaleAspectFit
        
        usernameLabel.font = SystemFont[.title]
        usernameLabel.textAlignment = .center
        
        rideDay.font = SystemFont[.title]
        ridePickup.font = SystemFont[.title]
        
        rideDate.font = SystemFont[.description]
        rideDate.textColor = Palette[.gray]
        
        ridePrice.font = SystemFont[.title]
        
        pitchLabel.font = SystemFont[.description]
        pitchLabel.textColor = Palette[.gray]
        
        coverView.backgroundColor = Palette[.primary]
        
        pitchLabel.text = "Pitch in"

        profileImageView.contentMode = .scaleAspectFit
        profileImageView.image = #imageLiteral(resourceName: "accPlaceholder")
        profileImageView.layer.cornerRadius = Configuration.GUI.UserImageCornerRadiusAccount
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = Palette[.white].cgColor
        profileImageView.layer.borderWidth = Configuration.GUI.UserImageBorderWidth
        
        
        alertController.addTextField { textfield in
            textfield.placeholder = "your message"
        }
        alertController.addAction(UIAlertAction(title: "Send", style: .default, handler: { _ in
            guard let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid, let rideUserId = self.ride?.userId, userId != rideUserId else {
                return
            }
            self.send(rideUserId: self.ride?.userId)
        }))
        alertController.addAction(UIAlertAction(title: "Storno", style: .default, handler: nil))
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                coverView,
                messageImageView,
                phoneImageView,
                profileImageView,
                pitchLabel,
                usernameLabel,
                rideDate,
                rideDay,
                ridePrice,
                ridePickup,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        messageImageView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(20)
            make.leading.equalTo(view).inset(10)
            make.trailing.equalTo(profileImageView.snp.leading).offset(10)
            make.height.equalTo(30)
        }
        
        phoneImageView.snp.makeConstraints { make in
            make.top.equalTo(view).inset(23)
            make.trailing.equalTo(view).inset(10)
            make.leading.equalTo(profileImageView.snp.trailing).offset(5)
            make.height.equalTo(30)
        }
        
        rideDay.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
        }
        
        rideDate.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(10)
            make.top.equalTo(usernameLabel.snp.bottom).offset(20)
            make.height.equalTo(25)
        }
        
        ridePrice.snp.makeConstraints { make in
            make.trailing.equalTo(view).inset(10)
            make.top.equalTo(rideDate.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        pitchLabel.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.top.equalTo(rideDay.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        ridePickup.snp.makeConstraints { make in
            make.leading.equalTo(view).inset(10)
            make.top.equalTo(pitchLabel.snp.bottom).offset(5)
            make.height.equalTo(25)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.height.equalTo(35)
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
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[.white]
    }

    // MARK: - User actions
    func createMessage() {
        
        present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func send(rideUserId: String?) {
        guard let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid, let userName = AccountSessionManager.manager.accountSession?.userInfo?.displayName, let message = alertController.textFields?.first?.text, let toUser = rideUserId, let rideUsername = ride?.username else {
            return
        }
        let timestamp = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: String.empty)
        let ref = FIRDatabase.database().reference(withPath: Configuration.Entits.Conversation)
        ref
            .child(userId)
            .child(String(timestamp))
            .setValue(
            [
                "from": userId,
                "to": toUser,
                "fromUser": userName,
                "toUser": rideUsername
            ]
        )
        let ref2 = FIRDatabase.database().reference(withPath: Configuration.Entits.Conversation)
        ref2
            .child(toUser)
            .child(String(timestamp))
            .setValue(
            [
                "from": userId,
                "to": toUser,
                "fromUser": userName,
                "toUser": rideUsername
            ]
        )
        let msgRef = FIRDatabase.database().reference(withPath: Configuration.Entits.Message)
        msgRef
            .child(String(timestamp))
            .childByAutoId()
            .setValue(
            [
                "id": String(timestamp),
                "fromId": userId,
                "fromUser": userName,
                "toId": toUser,
                "toUser": rideUsername,
                "text": message,
                "createdAt": "\(Date())",
            ]
        )
    }
}
