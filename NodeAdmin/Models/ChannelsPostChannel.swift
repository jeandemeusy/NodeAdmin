//
//  ChannelsPost.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/13/24.
//

import Foundation


struct ChannelsPostChannel: Codable {
    let channelId: String
    let transactionReceipt: String
    
    enum CodingKeys: String, CodingKey {
        case channelId, transactionReceipt
    }
}
