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
}

// MARK: Tokens
extension AccountBalances {
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

// MARK: Previews
extension AccountBalances {
    static var preview: AccountBalances {
        AccountBalances(weiNative: "100000000000000000", weiHopr: "0", weiSafeNative: "0", weiSafeHopr: "28487483734000000000000", weiSafeHoprAllowance: "43382928382")
    }
    
    static var null: AccountBalances {
        AccountBalances(weiNative: "0", weiHopr: "0", weiSafeNative: "0", weiSafeHopr: "0", weiSafeHoprAllowance: "0")
    }
}
