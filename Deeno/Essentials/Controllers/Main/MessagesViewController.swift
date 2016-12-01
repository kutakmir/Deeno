//
//  MessagesViewController.swift
//  Deeno
//
//  Created by Michal Severín on 03.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import UIKit

class MessagesViewController: AbstractViewController {
    
    enum MessageState: String {
        
        case sent = "true"
        case recieve = "false"
        case unknown
        
        init(state: String) {
            self = MessageState(rawValue: state) ?? .unknown
        }
    }

    // MARK: - Properties
    // MARK: Public Properties
    var ride: Rides? {
        didSet {
            guard let userId = ride?.userId else {
                return
            }
            toUserID = userId
        }
    }
    
    var senderUserId: String? {
        didSet {
            guard let userId = senderUserId else {
                return
            }
            toUserID = userId
        }
    }
    
    var conversation: Conversation?
    var conversationId: String?
    var toUserName: String?
    
    // MARK: Private Properties
    fileprivate var messages: [Message] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let tableView = TableView(frame: .zero, style: .grouped)
    
    fileprivate let messageTextField = TextField()
    
    fileprivate var toUserID: String?
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        messageTextField.placeholder = "message"
        messageTextField.addTarget(self, action: #selector(sendMessage), for: .editingDidEndOnExit)
        
        tableView.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.separatorColor = Palette[.clear]
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                tableView,
                messageTextField,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        messageTextField.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(messageTextField.snp.top)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[.white]
    }
    
    internal override func customInit() {
        super.customInit()

        tableView.register(MessagesTableViewCell.self)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessagesViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    internal override func loadData() {
        super.loadData()
        
        loadMessages()
    }

    
    // MARK: - User Action
    func sendMessage() {
        send()
    }
    
    // MARK: - Actions
    fileprivate func loadMessages() {
        guard let conversationId = conversationId else {
            return
        }
        FIRDatabase.database()
            .reference(withPath: Configuration.Entits.Message)
            .child(conversationId)
            .observe(.value, with: { snapshot in
                self.messages.removeAll()
                for item in snapshot.children {
                    if let item = item as? FIRDataSnapshot, let message = Message(snapshot: item) {
                        self.messages.append(message)
                    }
                }
            }
        )
    }

    fileprivate func send() {
        guard let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid, let userName = AccountSessionManager.manager.accountSession?.userInfo?.displayName, let message = messageTextField.text, let conversation = conversation, let key = conversationId, let conversationFrom = conversation.from, let conversationTo = conversation.to, let fromName = conversation.fromUser, let toName = conversation.toUser else {
            return
        }
        let timestamp = String(Date().timeIntervalSince1970).replacingOccurrences(of: ".", with: String.empty)
        let msgRef = FIRDatabase.database().reference(withPath: Configuration.Entits.Message)
        msgRef
            .child(key)
            .childByAutoId()
            .setValue(
            [
                "id": String(timestamp),
                "fromId": userId,
                "fromUser": userName,
                "toId": conversationFrom == userId ? conversationTo : conversationFrom,
                "toUser": fromName == userName ? toName : fromName,
                "text": message,
                "createdAt": "\(Date())",
            ]
        )
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            messageTextField.snp.remakeConstraints { make in
                make.height.equalTo(40)
                make.leading.equalTo(view)
                make.trailing.equalTo(view)
                make.bottom.equalTo(view).inset(keyboardSize.height)
            }
        }
        UIView.animate(withDuration: Configuration.DefaultAnimationTimeInterval, animations: { _ in
            self.messageTextField.layoutIfNeeded()
            }, completion: { _ in  }
        )
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.messageTextField.snp.remakeConstraints { make in
            make.height.equalTo(40)
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        UIView.animate(withDuration: Configuration.DefaultAnimationTimeInterval, animations: { _ in
            self.messageTextField.layoutIfNeeded()
            }, completion: { _ in  }
        )
    }
}

// MARK: - <UITableViewDataSource>
extension MessagesViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        if let msg = messages[safe: indexPath.row], let from = msg.fromId {
            if from == AccountSessionManager.manager.accountSession?.userInfo?.uid ?? "" {
                cell.inset = UIEdgeInsets(top: 0, left: 50, bottom: 5, right: 5)
                cell.content.messageLabel.textAlignment = .right
            }
            else {
                cell.inset = UIEdgeInsets(top: 0, left: 5, bottom: 5, right: 50)
                cell.content.messageLabel.textAlignment = .left
            }
            cell.content.message = msg.text ?? String.empty
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
}

// MARK: - <UITableViewDelegate>
extension MessagesViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
