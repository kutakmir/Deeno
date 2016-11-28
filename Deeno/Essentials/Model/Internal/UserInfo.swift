//
//  UserInfo.swift
//  Deeno
//
//  Created by Michal Severín on 28.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import FirebaseAuth
import Foundation

struct UserInfo {

    var uid: String?
    var displayName: String?
    var email: String?
    var photoURL: URL?

    init(user: FIRUser) {
        self.uid = user.uid
        self.displayName = user.displayName
        self.email = user.email
        self.photoURL = user.photoURL
    }

    init(snapshot: FIRDataSnapshot) {
        self.uid = snapshot.key
        if let value = snapshot.value as? [String: Any] {
            self.displayName = value["displayName"] as? String
            self.email = value["email"] as? String
            self.photoURL = URL(string: "\(value["photoURL"])")
        }
    }

    static func isUser(uid: String) -> Bool {
        guard let user = FIRAuth.auth()?.currentUser else {
            return false
        }
        return uid == user.uid
    }
}

// MARK: - <StaticSerializable>
extension UserInfo: StaticSerializable {

    // MARK: Static Properties
    static let serializableKey = UserDefaults.UserDefaultsKeys.userProfileInfo

    // MARK: Constructor
    init?(dictionary: [String: Any]?) {
        uid = dictionary?["uid"] as? String
        displayName = dictionary?["displayName"] as? String
        email = dictionary?["email"] as? String
    }

    // MARK: Public methods
    func encode() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        dictionary["uid"] = uid
        dictionary["displayName"] = displayName
        dictionary["email"] = email
        return dictionary
    }
}
