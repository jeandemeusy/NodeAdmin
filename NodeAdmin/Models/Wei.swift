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
    
    init(_ _value: String, unit: String) {
        self._value = _value
        self.unit = unit
    }
    
    var reduced: Double {
        return Double(_value)! / 1e18
    }
    
    var value: String {
        return "\(reduced.formatted())"

    }
    var valueWithUnit: String {
        return "\(reduced.rounded(2).formatted()) \(unit)"
    }
}
