//
//  AppIntent.swift
//  NodeAdminWidget
//
//  Created by Jean Demeusy on 2/18/24.
//

import WidgetKit
import AppIntents


struct SelectNodeAndAssetIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SelectNodeAndAssetIntent"
    static var description = IntentDescription("NodeAdmin widget, with selectable node and asset")

    @Parameter(title: "Node", optionsProvider: AccountProvider())
    var selectedNode: String
    
    @Parameter(title: "Asset", optionsProvider: AssetProvider())
    var selectedAsset: String                                                  
}

extension SelectNodeAndAssetIntent {
    struct AccountProvider: DynamicOptionsProvider {
        func results() async throws -> [String] { return getSavedAccounts().map { $0.nickname } }
    }
    
    struct AssetProvider: DynamicOptionsProvider {
        func results() async throws -> [String] { return ["Safe native", "Safe HOPR", "Node native", "Node HOPR", "Allowance"] }
    }
}
