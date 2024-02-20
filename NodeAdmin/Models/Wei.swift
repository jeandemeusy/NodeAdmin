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
    
    
    init(_ _strValue: String, unit: String) {
        self._value = _strValue
        self.unit = unit
    }
    
    init(_ _intValue: Int, unit: String) {
        self._value = String(_intValue)
        self.unit = unit
    }
    
    var reduced: Double {
        return Double(_value)! / 1e18
    }
    
    var value: String {
        return "\(reduced.rounded(2).formatted())"

    }
    var valueWithUnit: String {
        return "\(reduced.rounded(2).formatted()) \(unit)"
    }
}
