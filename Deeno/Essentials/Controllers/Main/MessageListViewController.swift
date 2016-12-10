//
//  MessageListViewController.swift
//  Deeno
//
//  Created by Michal Severín on 04.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import UIKit

class MessageListViewController: AbstractViewController {

    // MARK: - Properties
    // MARK: Private Properties
    fileprivate var conversations: [Conversation] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    fileprivate let tableView = TableView(frame: .zero, style: .grouped)

    // MARK: - Initialize
    internal override func initializeElements() {
        super.initializeElements()
        
        tableView.contentInset = UIEdgeInsets(top: -33, left: 0, bottom: 0, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    internal override func addElements() {
        super.addElements()
        
        view.addSubviews(views:
            [
                tableView,
            ]
        )
    }
    
    internal override func setupConstraints() {
        super.setupConstraints()
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func setupView() {
        super.setupView()
        
        view.backgroundColor = Palette[.white]
        navigationItem.title = "Messages"
    }
    
    internal override func customInit() {
        super.customInit()
        
        tableView.register(UITableViewCell.self)
    }
    
    internal override func loadData() {
        super.loadData()
        
        loadConversations()
    }

    // MARK: - Actions
    fileprivate func loadConversations() {
        guard let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid else {
            return
        }
        FIRDatabase.database()
            .reference(withPath: Configuration.Entits.Conversation)
            .child(userId)
            .observe(.value, with: { snapshot in
                self.conversations.removeAll()
                for item in snapshot.children {
                    if let item = item as? FIRDataSnapshot, let conversation = Conversation(snapshot: item) {
                        self.conversations.append(conversation)
                    }
                }
            }
        )
    }
}

// MARK: - <UITableViewDataSource>
extension MessageListViewController: UITableViewDataSource {
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.selectionStyle = .none
        
        if let userId = AccountSessionManager.manager.accountSession?.userInfo?.uid {
            if let conversation = conversations[safe: indexPath.row], let to = conversation.to, let fromName = conversation.fromUser, let toName = conversation.toUser {
                cell.textLabel?.text = to == userId ? fromName : toName
                cell.imageView?.image = #imageLiteral(resourceName: "accPlaceholder")
                cell.imageView?.contentMode = .scaleAspectFit
                cell.imageView?.layer.cornerRadius = (cell.imageView?.frame.size.width)! / 2
            }
        }

        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
}

// MARK: - <UITableViewDelegate>
extension MessageListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let conversation = conversations[safe: indexPath.row] {
            let msgs = MessagesViewController()
            msgs.hidesBottomBarWhenPushed = true
            msgs.conversation = conversation
            msgs.conversationId = conversation.key
            navigationController?.pushViewController(msgs, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return Configuration.GUI.DefaultCellHeight
    }
}
