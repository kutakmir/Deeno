//
//  Message.swift
//  Deeno
//
//  Created by Michal Severín on 03.12.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase

struct Message {
    
    var key: String?
    var id: String?
    var fromUser: String?
    var fromId: String?
    var toUser: String?
    var toId: String?
    var text: String?
    var createdAt: Date?
    var ref: FIRDatabaseReference?

    init?(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: String] {
            key = snapshot.key
            id = snapshotValue["id"]
            toUser = snapshotValue["toUser"]
            fromId = snapshotValue["fromId"]
            fromUser = snapshotValue["fromUser"]
            toId = snapshotValue["toId"]
            text = snapshotValue["text"]
            createdAt = TimeFormatsEnum.dateTime.dateFromString(snapshotValue["createdAt"])
            ref = snapshot.ref
        }
    }
}

struct Conversation {
    
    var key: String?
    var from: String?
    var to: String?
    var fromUser: String?
    var toUser: String?
    
    init?(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: String] {
            key = snapshot.key
            from = snapshotValue["from"]
            to = snapshotValue["to"]
            fromUser = snapshotValue["fromUser"]
            toUser = snapshotValue["toUser"]
        }
    }
}
