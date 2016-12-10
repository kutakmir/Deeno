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
    
    var conversation: Conversation? {
        didSet {
            guard let myId = AccountSessionManager.manager.accountSession?.userInfo?.uid, let from = conversation?.from else {
                return
            }
            if let fromUser = conversation?.fromUser, let toUser = conversation?.toUser {
                navigationItem.title = myId == from ? toUser : fromUser
            }
        }
    }
    var conversationId: String?

    
    // MARK: Private Properties
    fileprivate var messages: [Message] = [] {
        didSet {
            messageTextView.text = String.empty
            tableView.reloadData()
        }
    }
    
    fileprivate let tableView = TableView(frame: .zero, style: .grouped)
    fileprivate let toolbar = UIToolbar()
    fileprivate let messageTextView = UITextView()
    fileprivate let sendButton = UIButton(type: .system)
    
    fileprivate var toUserID: String?
    
    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        toolbar.tintColor = Palette[.white]
        toolbar.isTranslucent = false
        toolbar.autoresizingMask = .flexibleWidth
        toolbar.backgroundColor = Palette[.primary]
        
        sendButton.tintColor = Palette[.primary]
        sendButton.setTitle("SEND", for: .normal)
        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    
        messageTextView.isScrollEnabled = false
        messageTextView.layer.cornerRadius = Configuration.GUI.ItemCornerRadius
        messageTextView.layer.borderWidth = Configuration.GUI.UserImageBorderWidth
        messageTextView.layer.borderColor = Palette[.lightGray].cgColor
        messageTextView.autoresizingMask = .flexibleWidth
        
        tableView.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorColor = Palette[.clear]
        tableView.addKeyboardPanning { frame, opening, closing in
            var toolBarFrame = self.toolbar.frame;
            toolBarFrame.origin.y = frame.origin.y - toolBarFrame.size.height
            self.toolbar.frame = toolBarFrame
        }
        tableView.keyboardTriggerOffset = toolbar.frame.size.height
    }
    
    internal override func addElements() {
        super.addElements()

        view.addSubviews(views:
            [
                tableView,
            ]
        )

        toolbar.addSubviews(views:
            [
                messageTextView,
                sendButton,
            ]
        )

        tableView.addSubview(toolbar)
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        sendButton.snp.makeConstraints { make in
            make.bottom.equalTo(toolbar).inset(5)
            make.trailing.equalTo(toolbar).inset(10)
            make.height.equalTo(30)
            make.width.equalTo(40)
        }
        
        toolbar.snp.makeConstraints { make in
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        messageTextView.snp.makeConstraints { make in
            make.leading.equalTo(toolbar).inset(5)
            make.trailing.equalTo(sendButton.snp.leading).offset(-10)
            make.top.equalTo(toolbar).inset(5)
            make.bottom.equalTo(toolbar).inset(5)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.leading.equalTo(view)
            make.trailing.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[.white]
    }
    
    internal override func customInit() {
        super.customInit()

        tableView.register(MessagesTableViewCell.self)
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
        guard let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid, let userName = AccountSessionManager.manager.accountSession?.userInfo?.displayName, let message = messageTextView.text, let conversation = conversation, let key = conversationId, let conversationFrom = conversation.from, let conversationTo = conversation.to, let fromName = conversation.fromUser, let toName = conversation.toUser else {
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
                "createdAt": TimeFormatsEnum.dateTime.stringFromDate(Date()),
            ]
        )
        view.endEditing(true)
    }
}

// MARK: - <UITableViewDataSource>
extension MessagesViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MessagesTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        cell.content.textColor = Palette[.black]
        
        if let msg = messages[safe: indexPath.row], let from = msg.fromId {
            if from == AccountSessionManager.manager.accountSession?.userInfo?.uid ?? "" {
                cell.inset = UIEdgeInsets(top: 0, left: (UIScreen.main.bounds.width / 2)-20, bottom: 10, right: 5)
                cell.content.alignment = .right
                cell.content.backgroundColor = Palette[.primary]
                cell.content.textColor = Palette[.white]
            }
            else {
                cell.inset = UIEdgeInsets(top: 0, left: 5, bottom: 10, right: (UIScreen.main.bounds.width / 2)-20)
                cell.content.alignment = .left
                cell.content.backgroundColor = Palette[.white]
            }
            cell.content.createdTime = TimeFormatsEnum.dateTime.stringFromDate(msg.createdAt)
            cell.content.message = msg.text
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
        return 80
    }
}
