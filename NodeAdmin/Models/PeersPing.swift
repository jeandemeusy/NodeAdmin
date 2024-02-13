//
//  File.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation

struct PeersPing: Codable {
    let latency: Int
    let version: String
    
    enum CodingKeys: String, CodingKey {
        case latency
        case version = "reportedVersion"
    }
}
