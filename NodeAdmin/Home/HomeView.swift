//
//  HomeViewRedo.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var apiVM: APIVM

    var body: some View {
        NavigationView {
            GeometryReader { geo in
                ScrollView {
                    LazyVStack(alignment:.leading) {
                        HStack(spacing: 20) {
                            Image("node")
                                .resizable()
                                .scaledToFit()
                                .frame(height:80)
                                .foregroundStyle(.darkForegroundDM)
                            
                            VStack(alignment: .leading) {
                                Text("\(apiVM.nickname)@\(apiVM.host)")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.2)
                                    .foregroundStyle(.grey)
                                Divider()
                                
                                Text("version: \(apiVM.version?.version ?? "-")")
                                Divider()
                                
                                Text("network: \(apiVM.info?.network ?? "-")")
                                Divider()
                                
                                Text("status: ") + Text(apiVM.info?.connectivityStatus ?? "-")
                                    .foregroundStyle(apiVM.info?.statusColor ?? .grey)
                                    .fontWeight(.bold)
                                
                            }
                            .font(.caption)
                        }
                        .lightBluePanel
                        .padding(.top)
                        .padding(.bottom, 5)
                        
                        Group {
                            Text("id: \(apiVM.addresses?.hopr ?? "-")")
                            Text("address: \(apiVM.addresses?.native ?? "-")")
                        }
                        .lineLimit(1)
                        .font(.custom("addresses", size: 8, relativeTo: .footnote))
                        .foregroundStyle(.darkForegroundSecondaryDM)
                        .monospaced()
                    
                        SectionTitle("Safe's assets")
                        HStack {
                            LightBlueTile(text: "HOPR", content: apiVM.balances?.safeHopr.valueWithUnit)
                            LightBlueTile(text: "Native", content: apiVM.balances?.safeNative.valueWithUnit)
                        }
                        LightBlueTile(text: "Allowance", content: apiVM.balances?.safeHoprAllowance.valueWithUnit)
                        
                        SectionTitle("Rewards")
                        LightBlueTile(text: "Redeemed", content: apiVM.statistics?.redeemedValue.valueWithUnit)
                        HStack {
                            LightBlueTile(text: "Unredeemed", content: apiVM.statistics?.unredeemedValue.valueWithUnit)
                            LightBlueTile(text: "Rejected", content: apiVM.statistics?.rejectedValue.valueWithUnit)
                                .frame(width: geo.size.width/3)
                        }
                        
                        SectionTitle("Channels")
                        LightBlueTile(text: "Outgoing channels funds", content: apiVM.channels?.outgoingBalanceString)
                        HStack {
                            LightBlueTile(text: "# Incoming", value: apiVM.channels?.incoming.count)
                            LightBlueTile(text: "# Outgoing", value: apiVM.channels?.outgoing.count)
                        }
                        
                    }
                    .padding(.horizontal, 10)
                }
            }
            .navigationTitle("Home")
            .refreshable { await apiVM.getAll() }
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(APIVM())
}
