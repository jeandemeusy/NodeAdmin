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
        return Wei(_value: weiNative, unit: "xDai")
    }
    
    var hopr: Wei {
        Wei(_value: weiHopr, unit: "wxHOPR")
    }
    
    var safeNative: Wei {
        Wei(_value: weiSafeNative, unit: "wxHOPR")
    }
    
    var safeHopr: Wei {
        Wei(_value: weiSafeHopr, unit: "wxHOPR")
    }
    
    var safeHoprAllowance: Wei {
        Wei(_value: weiSafeHoprAllowance, unit: "wxHOPR")
    }
}
