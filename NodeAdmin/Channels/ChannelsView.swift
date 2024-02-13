//
//  ChannelsView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct ChannelsView: View {
    @StateObject var aliasesVM = AliasesVM()
    @StateObject var channelsVM = ChannelsVM()
    @StateObject var nodeVM = NodeVM()
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    LightBlueTile(text: "Outgoing channels funds", content:
                                    channelsVM.channels?.outgoingBalanceString)
                    HStack {
                        LightBlueTile(text: "# Incoming", value: channelsVM.channels?.incoming.count)
                        LightBlueTile(text: "# Outgoing", value: channelsVM.channels?.outgoing.count)
                    }
                    
                    SectionTitle("Outgoing")
                    ForEach(outgoingChannels, id: \.id) { channel in
                        ChannelItemView(channel: channel)
                    }
                    
                    SectionTitle("Incoming")
                    ForEach(incomingChannels, id: \.id) { channel in
                        ChannelItemView(channel: channel)
                    }
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Channels")
        }
        .onAppear {
            aliasesVM.getAliases(for: host, key: token)
            channelsVM.getChannels(for: host, key: token)
            nodeVM.getPeers(for: host, key: token)
        }
    }
    
    var outgoingChannels: [Channel] {
        let outgoing = channelsVM.channels?.outgoing ?? []
        let peers = nodeVM.peers?.connected ?? []
        
        var tempOutput: [Channel] = []
        for channel in outgoing {
            var temp = channel
            temp.peer = peers.first { $0.peerAddress == channel.peerAddress }
            tempOutput.append(temp)
        }
        
        var output: [Channel] = []
        if let aliases = aliasesVM.aliases {
            for channel in tempOutput {
                if channel.peer == nil {
                    continue
                }
                var temp = channel
                temp.peer!.alias = aliases.key(for: temp.peer!.peerId)
                output.append(temp)
            }
        }
    
        return output.sorted { $0.displayName < $1.displayName }
    }
    
    var incomingChannels: [Channel] {
        let outgoing = channelsVM.channels?.incoming ?? []
        let peers = nodeVM.peers?.connected ?? []
        
        var tempOutput: [Channel] = []
        for channel in outgoing {
            var temp = channel
            temp.peer = peers.first { $0.peerAddress == channel.peerAddress }
            tempOutput.append(temp)
        }
        
        var output: [Channel] = []
        if let aliases = aliasesVM.aliases {
            for channel in tempOutput {
                if channel.peer == nil {
                    continue
                }
                var temp = channel
                temp.peer!.alias = aliases.key(for: temp.peer!.peerId)
                output.append(temp)
            }
        }
    
        return output.sorted { $0.displayName < $1.displayName }
    }
    
}

#Preview {
    ChannelsView()
}
