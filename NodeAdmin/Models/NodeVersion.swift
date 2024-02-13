//
//  NodeVersion.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

struct NodeVersion {
    let version: String
    
    static var preview: NodeVersion {
        return NodeVersion(version: "2.0.8")
    }
}
