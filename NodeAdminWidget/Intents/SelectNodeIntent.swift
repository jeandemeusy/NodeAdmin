//
//  SelectNodeIntent.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import WidgetKit
import AppIntents


struct SelectNodeIntent: AppIntent, WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SelectNodeIntent"
    static var description = IntentDescription("NodeAdmin widget, with selectable node")

    @Parameter(title: "Node", optionsProvider: AccountProvider())
    var selectedNode: String
}

extension SelectNodeIntent {
    struct AccountProvider: DynamicOptionsProvider {
        func results() async throws -> [String] { return getSavedAccounts().map { $0.nickname } }
    }
}
