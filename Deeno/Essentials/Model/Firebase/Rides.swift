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
    var date: String?
    var departure: String?
    var freeSeats: String?
    var price: String?
    var userId: String?
    var ref: FIRDatabaseReference?

    init(snapshot: FIRDataSnapshot) {
        if let snapshotValue = snapshot.value as? [String: String] {
            key = snapshot.key
            date = snapshotValue["data"]
            departure = snapshotValue["departure"]
            freeSeats = snapshotValue["freeSeats"]
            price = snapshotValue["price"]
            userId = snapshotValue["userId"]
            ref = snapshot.ref
        }
    }
}
