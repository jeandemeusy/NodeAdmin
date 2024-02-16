//
//  SavedAccount.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/16/24.
//

import Foundation

struct SavedAccount: Codable, Hashable {
    let nickname: String
    let host: String
    let token: String
}
