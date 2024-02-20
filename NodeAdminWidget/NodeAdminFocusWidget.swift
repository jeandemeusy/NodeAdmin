//
//  NodeAdminFocusWidget.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import WidgetKit
import SwiftUI
import Alamofire


struct NodeAndAssetProvider: AppIntentTimelineProvider {
    typealias Entry = BalanceEntry
    typealias Intent = SelectNodeAndAssetIntent
    
    func placeholder(in context: Context) -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview, asset: "Safe HOPR")
    }
    
    func snapshot(for configuration: SelectNodeAndAssetIntent, in context: Context) async -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview, asset: "Safe HOPR")
    }
    
    func timeline(for configuration: SelectNodeAndAssetIntent, in context: Context) async -> Timeline<BalanceEntry> {
        let accounts = getSavedAccounts()
        let account = accounts.filter({ $0.nickname == configuration.selectedNode }).first
        
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 30), to: Date())!
        
        if let account = account {
            let balances = await fetchEntry(account: account)
            
            let entry = BalanceEntry(date: Date(), account: account, balances: balances, asset: configuration.selectedAsset)
            return Timeline(entries: [entry], policy: .after(nextUpdate))
        }
        
        return Timeline(entries: [BalanceEntry(date: Date(), account: account, balances: AccountBalances.null, asset: "Safe HOPR")], policy: .after(nextUpdate))
    }
    
    func fetchEntry(account: SavedAccount, completion: @escaping (AccountBalances?) -> Void) {
        let url = buildURL(host: account.host, path: "account/balances")
        let request = try? URLRequest(url: url, method: .get, headers: HTTPHeaders(["x-auth-token": account.token]))
        
        URLSession.shared.dataTask(with: request!) { data, response, error in
            if let data = data {
                if let entry = try? JSONDecoder().decode(AccountBalances.self, from: data) {
                    completion(entry)
                    return
                }
            }
            completion(nil)
        }.resume()
    }
    
    func fetchEntry(account: SavedAccount) async -> AccountBalances? {
        await withUnsafeContinuation { continuation in
            fetchEntry(account: account) { entry in
                continuation.resume(returning: entry)
            }
        }
    }
}

struct SmallNodeAdminFocusWidgetEntryView: View {
    let entry: BalanceEntry

    var body: some View {
        VStack {
            HStack {
                Circle()
                    .foregroundStyle(._yellowHOPR)
                    .frame(maxHeight: 30)
                Spacer()
                if let account = entry.account {
                    Text(account.nickname)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .monospaced()
                        .foregroundStyle(.darkForegroundDM)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                }
            }
            Divider()
            Spacer()
            VStack {
                Text(entry.asset ?? "-")
                    .font(.caption2)
                Text(asset.value)
                    .font(.title)
                    .fontWeight(.black)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text(asset.unit)
                    .fontWeight(.thin)
            }
            .monospaced()
        
            Spacer()
        }
        .padding(10)
    }
    
    var asset: Wei {
        if let balances = entry.balances {
            if let selection = entry.asset {
                switch selection {
                case "Safe native":
                    return balances.safeNative
                case "Safe HOPR":
                    return balances.safeHopr
                case "Node native":
                    return balances.native
                case "Node HOPR":
                    return balances.hopr
                case "Allowance":
                    return balances.safeHoprAllowance
                default: return Wei("0", unit: "-")
                }
            }
        }
        return Wei("0", unit: "-")
    }
}

struct SmallNodeAdminFocusWidget: Widget {
    let kind: String = "NodeAdminFocusWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
             kind: kind,
             intent: SelectNodeAndAssetIntent.self,
             provider: NodeAndAssetProvider()) { entry in
                 SmallNodeAdminFocusWidgetEntryView(entry: entry)
                     .containerBackground(.lightBackgroundDM, for: .widget)
         }
        
        .contentMarginsDisabled() // Here
        .configurationDisplayName("NodeAdmin focus Widget")
        .description("Focus on your safe wxHOPR balance")
        .supportedFamilies([.systemSmall])
    }
}

#Preview("smallFocus", as: .systemSmall) {
    SmallNodeAdminFocusWidget()
} timeline: {
    BalanceEntry(date: .now, account: .preview, balances: AccountBalances.preview, asset: "Safe HOPR")
}
