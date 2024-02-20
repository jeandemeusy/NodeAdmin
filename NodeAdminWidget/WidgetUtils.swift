//
//  Utils.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import Foundation
import WidgetKit


struct BalanceEntry: TimelineEntry, Decodable {
    let date: Date
    let account: SavedAccount?
    let balances: AccountBalances?
    var asset: String? = nil
}

func getSavedAccounts() -> [SavedAccount] {
    var data = [SavedAccount]()
    if let savedData = UserDefaults.group!.object(forKey: "credentials") as? Data {
        do {
            data = try JSONDecoder().decode([SavedAccount].self, from: savedData)
        } catch {
            // Failed to convert Data to SavedAccount
        }
    }
    return data
}
