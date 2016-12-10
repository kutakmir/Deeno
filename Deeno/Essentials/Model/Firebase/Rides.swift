//
//  Rides.swift
//  Deeno
//
//  Created by Michal Severín on 28.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase

struct Rides {

    var key: String?
    var date: Date?
    var departure: String?
    var destination: String?
    var freeSeats: String?
    var price: String?
    var userId: String?
    var username: String?
    var userPhone: String?
    var ref: FIRDatabaseReference?

    init(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: String] {
            key = snapshot.key
            date = TimeFormatsEnum.dateTime.dateFromString(snapshotValue["date"])
            destination = snapshotValue["destination"]
            departure = snapshotValue["departure"]
            freeSeats = snapshotValue["freeSeats"]
            price = snapshotValue["price"]
            userId = snapshotValue["userId"]
            username = snapshotValue["username"]
            userPhone = snapshotValue["userPhone"]
            ref = snapshot.ref
        }
    }
}
