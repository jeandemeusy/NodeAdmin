//
//  SavedAccount.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/16/24.
//

import Foundation
import AppIntents

struct SavedAccount: Codable, Hashable, AppEntity {
    let nickname: String
    let host: String
    let token: String
    
    init(nickname: String, host: String, token: String) {
        self.nickname = nickname
        self.host = host
        self.token = token
        self.id = UUID().uuidString
    }
    
    static var preview: SavedAccount {
        SavedAccount(nickname: "Node #1", host: "http://host:port", token: "^MyT0ken^")
    }
    
    static var null: SavedAccount {
        SavedAccount(nickname: "-", host: "", token: "")
    }
    
    
    // For intents
    var id: String
    static var defaultQuery = NodeQuery()
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Node"
    
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(stringLiteral: nickname)
        
        
    }
}


struct NodeQuery: EntityQuery {
    func entities(for identifiers: [SavedAccount.ID]) -> [SavedAccount] {
        if let savedData = UserDefaults.group!.object(forKey: "credentials") as? Data {
            do {
                 return try JSONDecoder().decode([SavedAccount].self, from: savedData)
            } catch {
                // Failed to convert Data to SavedAccount
            }
        }
        return []
   }
   
   func suggestedEntities() -> [SavedAccount] {
       entities(for: [])
   }
   
   func defaultResult() -> SavedAccount? {
       suggestedEntities().first
   }
}
