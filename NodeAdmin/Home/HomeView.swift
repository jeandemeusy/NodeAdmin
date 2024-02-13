//
//  HomeViewRedo.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct SectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        HStack {
            Text(title)
                .monospaced()
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.top)
            Spacer()
        }
    }
}

struct LightBlueTile: View {
    var text: String
    var content: String
    
    init(text: String, value: Int?) {
        self.text = text
        if let value = value {
            self.content = String(value)
        } else {
            self.content = "-"
        }
    }
    
    init(text: String, value: Double?) {
        self.text = text
        if let value = value {
            self.content = String(value)
        } else {
            self.content = "-"
        }
    }
    
    init(text: String, content: String?) {
        self.text=text
        self.content = content ?? "-"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.headline.weight(.bold))
                .foregroundStyle(.darkBlueHOPR)
            
            HStack {
                Spacer()
                Text(content)
                    .font(.headline.weight(.medium))
                    .lineLimit(1)
            }
            .foregroundStyle(.grey)
        }
        .monospaced()
        .lightBluePanel

    }
}

struct HomeView: View {
    @EnvironmentObject var aliasesVM: AliasesVM
    @EnvironmentObject var accountVM: AccountVM
    @EnvironmentObject var channelsVM: ChannelsVM
    @EnvironmentObject var nodeVM: NodeVM
    @EnvironmentObject var ticketsVM: TicketsVM
    
    @AppStorage("host") private var host = ""

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(alignment:.leading) {
                    HStack(spacing: 20) {
                        Image("node")
                            .resizable()
                            .scaledToFit()
                            .frame(height:80)
                            .foregroundStyle(.darkBlueHOPR)
                        
                        VStack(alignment: .leading) {
                            Text(host)
                                .lineLimit(1)
                                .foregroundStyle(.grey)
                            Divider()
                            
                            Text("version: \(nodeVM.version?.version ?? "-")")
                            Divider()
                            
                            Text("network: \(nodeVM.info?.network ?? "-")")
                            Divider()
                            
                            Text("status: ") + Text(nodeVM.info?.connectivityStatus ?? "-")
                                .foregroundStyle(nodeVM.info?.statusColor ?? .grey)
                                .fontWeight(.bold)
                            
                        }
                        .font(.caption)
                    }
                    .lightBluePanel
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.darkBlueHOPR, lineWidth: 1)
                    )
                    .padding(.top)
                    .padding(.bottom, 5)
                    
                    Group {
                        Text("id: \(accountVM.addresses?.hopr ?? "-")")
                        Text("address: \(accountVM.addresses?.native ?? "-")")
                    }
                    .lineLimit(1)
                    .font(.custom("addresses", size: 8, relativeTo: .footnote))
                    .foregroundStyle(.secondary)
                    .monospaced()
                
                    SectionTitle("Safe's assets")
                    HStack {
                        LightBlueTile(text: "HOPR", content: accountVM.balances?.safeHopr.valueWithUnit)
                        
                        LightBlueTile(text: "Native", content: accountVM.balances?.safeNative.valueWithUnit)
                    }
                    
                    LightBlueTile(text: "Allowance", content: accountVM.balances?.safeHoprAllowance.valueWithUnit)
                    
                    SectionTitle("Rewards")
                        
                    LightBlueTile(text: "Redeemed", content: ticketsVM.statistics?.redeemedValue.valueWithUnit)
                    HStack {
                        LightBlueTile(text: "Unredeemed", content: ticketsVM.statistics?.unredeemedValue.valueWithUnit)
                        LightBlueTile(text: "Rejected", content:
                                        ticketsVM.statistics?.rejectedValue.valueWithUnit)
                    }
                    
                    SectionTitle("Channels")
                    LightBlueTile(text: "Outgoing channels funds", content:
                                    channelsVM.channels?.outgoingBalanceString)
                    HStack {
                        LightBlueTile(text: "# Incoming", value: channelsVM.channels?.incoming.count)
                        LightBlueTile(text: "# Outgoing", value:
                            channelsVM.channels?.outgoing.count)
                    }
                    
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Home")
            .refreshable { await reload() }
        }
    }
    
    func reload() async {
        aliasesVM.getAll()
        accountVM.getAll()
        channelsVM.getAll()
        nodeVM.getAll()
        ticketsVM.getAll()
    }
}

#Preview {
    HomeView()
        .environmentObject(AliasesVM())
        .environmentObject(AccountVM())
        .environmentObject(ChannelsVM())
        .environmentObject(NodeVM())
        .environmentObject(TicketsVM())
}
