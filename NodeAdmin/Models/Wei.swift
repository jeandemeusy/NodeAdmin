//
//  Wei.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation

struct Wei {
    let _value: String
    let unit: String
    
    var reduced: Double {
        return Double(_value)! / 1e18
    }
    
    var value: String {
        return "\(reduced.formatted())"

    }
    var valueWithUnit: String {
        return "\(reduced.formatted()) \(unit)"
    }
}
