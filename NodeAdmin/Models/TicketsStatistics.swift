//
//  TicketsStatistics.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

struct TicketsStatistics: Codable {
    let pending: Int
    let unredeemed: Int
    let weiUnredeemedValue: String
    let redeemed: Int
    let weiRedeemedValue: String
    let losingTickets: Int
    let winProportion: Int
    let neglected: Int
    let weiNeglectedValue: String
    let rejected: Int
    let weiRejectedValue: String
    
    enum CodingKeys: String, CodingKey {
        case pending, unredeemed
        case weiUnredeemedValue = "unredeemedValue"
        case redeemed
        case weiRedeemedValue = "redeemedValue"
        case losingTickets, winProportion, neglected
        case weiNeglectedValue = "neglectedValue"
        case rejected
        case weiRejectedValue = "rejectedValue"
    }
    
    var unredeemedValue: Wei {
        Wei(_value: weiUnredeemedValue, unit: "wxHOPR")
    }
    
    var redeemedValue: Wei {
        Wei(_value: weiRedeemedValue, unit: "wxHOPR")
    }
    
    var neglectedValue: Wei {
        Wei(_value: weiNeglectedValue, unit: "wxHOPR")
    }
    
    var rejectedValue: Wei {
        Wei(_value: weiRejectedValue, unit: "wxHOPR")
    }
}
