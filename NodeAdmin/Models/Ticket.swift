//
//  TicketsTickets.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import Foundation

struct Ticket: Codable, Hashable {
    let channelId: String
    let weiAmount: String
    let index: String
    let indexOffset: String
    let winProb: String
    let channelEpoch: String
    
    enum CodingKeys: String, CodingKey {
        case channelId
        case weiAmount = "amount"
        case index, indexOffset, winProb, channelEpoch
    }
}


// MARK: Tokens
extension Ticket {
    var amount: Wei {
        return Wei(weiAmount, unit: "wxHOPR")
    }
}

extension Array where Element == Ticket {
    var value: Wei {
        return Wei(self.map { $0.amount._value }.reduce(0, { $0 + (Int($1) ?? 0)}), unit: "wxHOPR")
    }
}

// MARK: Preview
extension Ticket {
    static var preview: Ticket {
        Ticket(channelId: "0x09234029390uf029du", weiAmount: randomString(length: 19), index: "1", indexOffset: "1", winProb: "1", channelEpoch: "1")
    }
}
