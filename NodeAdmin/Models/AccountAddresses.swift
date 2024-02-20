//
//  NodeAddresses.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import Foundation

struct AccountAddresses: Codable {
    let native: String
    let hopr: String
    
    enum CodingKeys: String, CodingKey {
        case native, hopr
    }
}

// MARK: Previews
extension AccountAddresses {
    static var preview: AccountAddresses {
        return AccountAddresses(native: "12D3KooWGpeHPBKhJiXDyWSfEDeLRp1HgFRURepm9G52b7nL7bTP", hopr: "0xdce8eedaa15364048c226311369851608be3d984")
    }
}
