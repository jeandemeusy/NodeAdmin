//
//  NodeAdminWidget.swift
//  NodeAdminWidget
//
//  Created by Jean Demeusy on 2/18/24.
//

import WidgetKit
import SwiftUI
import Alamofire

struct BalancesFetcher {
    
    static func getSavedAccounts() -> [SavedAccount] {
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
}


struct NodeProvider: AppIntentTimelineProvider {
    typealias Entry = BalanceEntry
    typealias Intent = ConfigurationAppIntent
    
    func placeholder(in context: Context) -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> BalanceEntry {
        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<BalanceEntry> {
        let accounts = BalancesFetcher.getSavedAccounts()
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

//struct Provider: TimelineProvider {
//    func placeholder(in context: Context) -> BalanceEntry {
//        return BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
//    }
//    
//    func getSnapshot(in context: Context, completion: @escaping (BalanceEntry) -> Void) {
//        let entry = BalanceEntry(date: Date(), account: .preview, balances: AccountBalances.preview)
//        
//        completion(entry)
//    }
//    
//    func getTimeline(in context: Context, completion: @escaping (Timeline<BalanceEntry>) -> Void) {
//        Task {
//            let account = BalancesFetcher.getSavedAccounts().first
//            
//            let nextUpdate = Calendar.current.date(byAdding: DateComponents(minute: 30), to: Date())!
//            var entry = BalanceEntry(date: Date(), account: account, balances: AccountBalances.null)
//            var timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
//
//            if let account = account {
//                AccountStore.shared.GET_balances(for: account.host, key: account.token) { result in
//                    switch result {
//                    case .success(let response):
//                        entry = BalanceEntry(date: Date(), account: account, balances: response)
//                        timeline = Timeline(entries: [entry], policy: .after(nextUpdate))
//                        completion(timeline)
//
//                    case .failure(let error):
//                        debugPrint(error)
//                    }
//                }
//            }
//        }
//    }
//}

struct BalanceEntry: TimelineEntry, Decodable {
    let date: Date
    let account: SavedAccount?
    let balances: AccountBalances?
}

struct PanelView: View {
    let line1: String
    let line2: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(line1)
                .bold()
            
            HStack {
                Spacer()
                Text(line2)
                    .lineLimit(1)
                    .minimumScaleFactor(0.9)
                    .fontWeight(.semibold)
            }
        }
        .font(.caption)
        .monospaced()
        .padding(5)
        .foregroundStyle(._darkBlueHOPR)
        .background(.lightgrey)
        .clipShape(.rect(cornerRadius: 10))

    }
}

struct NodeAdminWidgetEntryView : View {
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

struct NodeAdminWidget: Widget {
    let kind: String = "NodeAdminWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
             kind: kind,
             intent: ConfigurationAppIntent.self,
             provider: NodeProvider()) { entry in
                 NodeAdminWidgetEntryView(entry: entry)
                     .containerBackground(.lightBackgroundDM, for: .widget)
         }
        
        .contentMarginsDisabled() // Here
        .configurationDisplayName("NodeAdmin Widget")
        .description("Node Admin for HOPR node monitoring")
//        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

#Preview(as: .systemSmall) {
    NodeAdminWidget()
} timeline: {
    BalanceEntry(date: .now, account: .preview, balances: AccountBalances.preview)
}
