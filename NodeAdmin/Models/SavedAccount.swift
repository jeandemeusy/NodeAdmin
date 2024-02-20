//
//  SavedAccount.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/16/24.
//

import Foundation
import AppIntents

struct SavedAccount: Codable, Hashable {
    let nickname: String
    let host: String
    let token: String
    
    init(nickname: String, host: String, token: String) {
        self.nickname = nickname
        self.host = host
        self.token = token
    }
}

// MARK: Previews
extension SavedAccount {
    static var preview: SavedAccount {
        SavedAccount(nickname: "Node #1", host: "http://host:port", token: "^MyT0ken^")
    }
    
    static var null: SavedAccount {
        SavedAccount(nickname: "-", host: "", token: "")
    }
}
