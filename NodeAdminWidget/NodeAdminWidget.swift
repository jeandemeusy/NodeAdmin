//
//  NodeAdminWidget.swift
//  NodeAdminWidget
//
//  Created by Jean Demeusy on 2/18/24.
//

import WidgetKit
import SwiftUI
import Alamofire


struct NodeProvider: AppIntentTimelineProvider {
    typealias Entry = BalanceEntry
    typealias Intent = SelectNodeIntent
    
    func placeholder(in context: Context) -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
    }
    
    func snapshot(for configuration: SelectNodeIntent, in context: Context) async -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
    }
    
    func timeline(for configuration: SelectNodeIntent, in context: Context) async -> Timeline<BalanceEntry> {
        let accounts = getSavedAccounts()
        let account = accounts.filter({ $0.nickname == configuration.selectedNode }).first
        
        let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 30), to: Date())!
        
        if let account = account {
            let balances = await fetchEntry(account: account)
            
            let entry = BalanceEntry(date: Date(), account: account, balances: balances)
            return Timeline(entries: [entry], policy: .after(nextUpdate))
        }
        
        return Timeline(entries: [BalanceEntry(date: Date(), account: account, balances: AccountBalances.null)], policy: .after(nextUpdate))
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


struct SmallNodeAdminWidgetEntryView : View {
    let entry: BalanceEntry
    
    var body: some View {
        VStack(spacing:2) {
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
            Spacer()
            if let balances = entry.balances {
                VStack(spacing:10) {
                    PanelView(line1: "HOPR", line2: balances.safeHopr.valueWithUnit)
                    PanelView(line1: "Native", line2: balances.native.valueWithUnit)
                }
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct LargeNodeAdminWidgetEntryView : View {
    let entry: BalanceEntry
    
    var body: some View {
        VStack(spacing:2) {
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
            if let balances = entry.balances {
                VStack(spacing:10) {
                    SectionTitle("Safe's assets")
                    PanelView(line1: "HOPR", line2: balances.safeHopr.valueWithUnit)
                    PanelView(line1: "Native", line2: balances.safeNative.valueWithUnit)
                    
                    SectionTitle("Node's assets")
                    PanelView(line1: "HOPR", line2: balances.hopr.valueWithUnit)
                    PanelView(line1: "Native", line2: balances.native.valueWithUnit)
                }
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 10)
    }
}

struct SmallNodeAdminWidget: Widget {
    let kind: String = "NodeAdminWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
             kind: kind,
             intent: SelectNodeIntent.self,
             provider: NodeProvider()) { entry in
                 SmallNodeAdminWidgetEntryView(entry: entry)
                     .containerBackground(.lightBackgroundDM, for: .widget)
         }
        
        .contentMarginsDisabled() // Here
        .configurationDisplayName("NodeAdmin Widget")
        .description("Node Admin for HOPR node monitoring")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct LargeNodeAdminWidget: Widget {
    let kind: String = "NodeAdminWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
             kind: kind,
             intent: SelectNodeIntent.self,
             provider: NodeProvider()) { entry in
                 LargeNodeAdminWidgetEntryView(entry: entry)
                     .containerBackground(.lightBackgroundDM, for: .widget)
         }
        
        .contentMarginsDisabled() // Here
        .configurationDisplayName("NodeAdmin Widget")
        .description("Node Admin for HOPR node monitoring")
        .supportedFamilies([.systemLarge])
    }
}

#Preview("smallOverview", as: .systemSmall) {
    SmallNodeAdminWidget()
} timeline: {
    BalanceEntry(date: .now, account: .preview, balances: AccountBalances.preview)
}


#Preview("mediumOverview", as: .systemMedium) {
    SmallNodeAdminWidget()
} timeline: {
    BalanceEntry(date: .now, account: .preview, balances: AccountBalances.preview)
}

#Preview("largeOverview", as: .systemLarge) {
    LargeNodeAdminWidget()
} timeline: {
    BalanceEntry(date: .now, account: .preview, balances: AccountBalances.preview)
}
