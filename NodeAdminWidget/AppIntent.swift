//
//  AppIntent.swift
//  NodeAdminWidget
//
//  Created by Jean Demeusy on 2/18/24.
//

import WidgetKit
import AppIntents

struct ConfigurationAppIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Configuration"
    static var description = IntentDescription("NodeAdmin widget, with selectable node")

    @Parameter(title: "Node", optionsProvider: AccountProvider())
    var selectedNode: String
}



extension ConfigurationAppIntent {
    struct AccountProvider: DynamicOptionsProvider {
        func results() async throws -> [String] {
            var accounts = [SavedAccount]()
            
            if let savedData = UserDefaults.group!.object(forKey: "credentials") as? Data {
                do {
                     accounts = try JSONDecoder().decode([SavedAccount].self, from: savedData)
                } catch {
                    // Failed to convert Data to SavedAccount
                }
            }
            return accounts.map { $0.nickname }
        }
    }
}
