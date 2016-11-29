//
//  AccountSession.swift
//  Deeno
//
//  Created by Michal Severín on 28.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Firebase
import Foundation

struct AccountSession {

    var userInfo: UserInfo? {
        didSet {
            guard let userInfo = userInfo else {
                return
            }
            userInfo.save()
        }
    }
    
    init?() {
        let userData = UserInfo.load()
        guard let user = userData, let _ = user.uid else {
            return nil
        }
        userInfo = userData
    }

    init?(user: FIRUser?) {
        guard let user = user else {
            return nil
        }
        userInfo = UserInfo(user: user)
        userInfo?.save()
    }
}
