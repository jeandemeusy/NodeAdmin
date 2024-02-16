//
//  AccountBalances.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import Foundation

struct AccountBalances: Codable {
    let weiNative: String
    let weiHopr: String
    let weiSafeNative: String
    let weiSafeHopr: String
    let weiSafeHoprAllowance: String
    
    enum CodingKeys: String, CodingKey {
        case weiNative = "native"
        case weiHopr = "hopr"
        case weiSafeNative = "safeNative"
        case weiSafeHopr = "safeHopr"
        case weiSafeHoprAllowance = "safeHoprAllowance"
    }
    
    var native: Wei {
        return Wei(weiNative, unit: "xDai")
    }
    
    var hopr: Wei {
        Wei(weiHopr, unit: "wxHOPR")
    }
    
    var safeNative: Wei {
        Wei(weiSafeNative, unit: "xDai")
    }
    
    var safeHopr: Wei {
        Wei(weiSafeHopr, unit: "wxHOPR")
    }
    
    var safeHoprAllowance: Wei {
        Wei(weiSafeHoprAllowance, unit: "wxHOPR")
    }
}
