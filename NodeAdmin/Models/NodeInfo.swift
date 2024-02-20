//
//  NodeInfo.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import SwiftUI

struct NodeInfo: Codable {
    let network: String
    let announcedAddress: [String]
    let listeningAddress: [String]
    let chain: String
    let hoprToken: String
    let hoprChannels: String
    let hoprNetworkRegistry: String
    let nodeManagementModule: String
    let nodeSafe: String
    let isEligible: Bool
    let connectivityStatus: String
    let channelClosurePeriod: Int
    
    enum CodingKeys: String, CodingKey {
        case network, announcedAddress, listeningAddress, chain, hoprToken, hoprChannels, hoprNetworkRegistry, nodeManagementModule, nodeSafe, isEligible, connectivityStatus, channelClosurePeriod
    }
}

// MARK: Computer
extension NodeInfo {
    var statusColor: Color {
        switch self.connectivityStatus {
        case "Green":
            return .green
        case "Orange":
            return .orange
        default:
            return .red
        }
    }
}
