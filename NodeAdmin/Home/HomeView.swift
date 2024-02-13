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
        Text(title)
            .monospaced()
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top)
    }
}
struct ListItem: View {
    var name: String
    var content: String?
    
    init(name: String, value: Int?) {
        self.name = name
        self.content = String(describing: value)
    }
    init(name: String, value: Double?) {
        self.name = name
        self.content = String(describing: value)
    }
    init(name: String, content: String?) {
        self.name = name
        self.content = content
    }
    
    var body: some View {
        HStack {
            Text(name)
                .fontWeight(.semibold)
                .lineLimit(1)
            Spacer()
            Text(content ?? "-")
            .monospaced(true)
            .lineLimit(1)
            .minimumScaleFactor(0.25)
        }
        .font(.footnote)
        .foregroundStyle(Color(white: 0.2))
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
            .foregroundStyle(Color(white: 0.2))
        }
        .monospaced()
        .lightBluePanel

    }
}

struct HomeView: View {
    @StateObject var accountVM = AccountVM()
    @StateObject var channelsVM = ChannelsVM()
    @StateObject var nodeVM = NodeVM()
    @StateObject var ticketsVM = TicketsVM()
    
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""
        
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
                                .foregroundStyle(Color(white: 0.2))
                            Divider()
                            
                            Text("version: \(nodeVM.version?.version ?? "-")")
                            Divider()
                            
                            Text("network: \(nodeVM.info?.network ?? "-")")
                            Divider()
                            
                            Text("status: ") + Text(nodeVM.info?.connectivityStatus ?? "-")
                                .foregroundStyle(nodeVM.info?.statusColor ?? Color(white: 0.2))
                                .fontWeight(.bold)
                            
                        }
                        .font(.caption)
                    }
                    .lightBluePanel
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.darkBlueHOPR, lineWidth: 1)
                    )
                    
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
        }
        .onAppear {
            accountVM.getAll(for: host, key: token)
            channelsVM.getAll(for: host, key: token)
            nodeVM.getAll(for: host, key: token)
            ticketsVM.getStatistics(for: host, key: token)
        }
    }
}

#Preview {
    HomeView()
}
