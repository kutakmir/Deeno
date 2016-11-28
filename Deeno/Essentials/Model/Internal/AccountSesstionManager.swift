//
//  AccountSessionManager.swift
//  Deeno
//
//  Created by Michal Severín on 28.11.16.
//  Copyright © 2016 Michal Severín. All rights reserved.
//

import Foundation

final class AccountSessionManager {

    var accountSession: AccountSession? {
        didSet {
            if accountSession == nil {
                UserInfo.clear()
            }
        }
    }

    static let manager = AccountSessionManager()
    private init() {
        accountSession = AccountSession()
    }

    func closeSession() {
        accountSession = nil
    }
}
