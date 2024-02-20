//
//  Utils.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import Foundation

func buildURL(host: String, path: String) -> String {
    return "\(host)/api/v3/\(path)"

}

func randomString(length: Int) -> String {
    let chars = "12345667890"
    return String((0..<length).map{ _ in chars.randomElement()! })
}
