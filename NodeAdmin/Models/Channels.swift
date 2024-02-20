//
//  ChannelsChannels.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import SwiftUI

struct Channels: Codable {
    let incoming: [Channel]
    let outgoing: [Channel]
    let all: [Channel]

    enum CodingKeys: String, CodingKey {
        case incoming, outgoing, all
    }
}

// MARK: Tokens
extension Channels {
    var outgoingBalance: Double {
        return outgoing.map { Double($0.balance.reduced) }.reduce(0) { $0 + $1 }
    }
    
    var outgoingBalanceString: String {
        return "\(outgoingBalance) wxHOPR"
    }
}

// MARK: Previews
extension Channels {
    static var preview: Channels {
        return Channels(incoming: [], outgoing: [Channel.preview], all: [])
    }
}


struct Channel: Codable {
    let type: String
    let id: String
    let peerAddress: String
    let status: String
    let weiBalance: String
    var peer: NodePeer?
    
    enum CodingKeys: String, CodingKey {
        case type, id, peerAddress, status
        case weiBalance = "balance"
    }
}

// MARK: Display
extension Channel {
    var directionImageName: String {
        switch type {
        case "incoming":
            return "arrow.down.left"
        case "outgoing":
            return "arrow.up.right"
        default:
            return "x.circle.fill"
        }
    }
    
    var directionColor: Color {
        switch type {
        case "incoming":
            return .red
        case "outgoing":
            return .green
        default:
            return .primary
        }
    }
    
    var directionPrefix: String {
        switch type {
        case "incoming":
            return "from"
        case "outgoing":
            return "to"
        default:
            return ""
        }
    }
    
    var displayName: String {
        if peer?.alias == nil {
            return peerAddress
        }
        return peer!.alias!
    }
    
    var statusColor: Color {
        switch status {
        case "Open":
            return .green
        case "PendingToClose":
            return .orange
        case "Closed":
            return .red
        default:
            return .primary
        }
    }
}

// MARK: Tokens
extension Channel {
    var balance: Wei {
        Wei(weiBalance, unit: "wxHOPR")
    }
}


// MARK: Previews
extension Channel {
    static var preview: Channel {
        return Channel(type: "outgoing", id: "0x2b0a5fea18f7c055df8f659214eac642ac346a94a3fbe7c376827a8883aa8780", peerAddress: "0x5a5bf3d3ce59cd304f198b86c1a78adfadf31f83", status: "Open", weiBalance: randomString(length: 21))
    }
}
