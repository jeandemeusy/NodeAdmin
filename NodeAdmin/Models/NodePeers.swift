//
//  NodePeers.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

struct NodePeers: Codable {
    let connected: [NodePeer]
    let announced: [NodePeer]
    
    enum CodingKeys: String, CodingKey {
        case connected, announced
    }
}

// MARK: Computed
extension NodePeers {
    var numConnected: Int {
        return connected.count
    }
    
    var numAnnounced: Int {
        return announced.count
    }
}

struct NodePeer: Codable {
    let peerId: String
    let peerAddress: String
    let multiAddr: String
    let heartbeats: Heartbeats
    let lastSeenInt: Int
    let quality: Double
    let backoff: Int
    let isNew: Bool
    let version: String
    var alias: String?
    var channel: String?
    
    enum CodingKeys: String, CodingKey {
        case peerId, peerAddress, multiAddr, heartbeats
        case lastSeenInt = "lastSeen"
        case quality, backoff, isNew
        case version = "reportedVersion"
        case alias, channel
    }
}

// MARK: Computed
extension NodePeer {
    var lastSeen: String {
        let date = Date(timeIntervalSince1970: TimeInterval(lastSeenInt/1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, hh:mm"
        return dateFormatter.string(from: date)
    }
    
    var displayName: String {
        if let alias = alias  {
            return alias
        }
        return peerId
    }
}

struct Heartbeats: Codable {
    let sent: Int
    let success: Int
    
    enum CodingKeys: String, CodingKey {
        case sent, success
    }
}

// MARK: Previews
extension Heartbeats {
    static var preview: Heartbeats {
        return Heartbeats(sent: 3088, success: 3084)
    }
}

extension NodePeer {
    static var preview: NodePeer {
        return NodePeer(peerId: "12D3KooWCq6sfR5nvCxKE3opwLbJa2pMBDFgeKR6aapDsf3Wv5Ci", peerAddress: "0x8fbc1256c4b974eae65840aa24ea67731361be56", multiAddr: "/ip4/173.249.26.138/tcp/9091", heartbeats: Heartbeats.preview, lastSeenInt: 1707644493238, quality: 1, backoff: 2, isNew: false, version: "2.0.7")
    }
}
