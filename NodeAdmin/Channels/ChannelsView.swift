//
//  ChannelsView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct ChannelsView: View {
    @EnvironmentObject var apiVM: APIVM

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    LightBlueTile(text: "Outgoing channels funds", content:
                                    apiVM.channels?.outgoingBalanceString)
                    HStack {
                        LightBlueTile(text: "# Incoming", value: apiVM.channels?.incoming.count)
                        LightBlueTile(text: "# Outgoing", value: apiVM.channels?.outgoing.count)
                    }
                    
                    SectionTitle("Outgoing")
                    ForEach(outgoingChannels, id: \.id) { channel in
                        NavigationLink {
                            ChannelDetailView(channel: channel, tickets: ticketsIn(channel))
                        } label: {
                            ChannelItemView(channel: channel, tickets: ticketsIn(channel))
                        }
                        
                    }
                    
                    SectionTitle("Incoming")
                    ForEach(incomingChannels, id: \.id) { channel in
                        NavigationLink {
                            ChannelDetailView(channel: channel, tickets: ticketsIn(channel))
                        } label: {
                            ChannelItemView(channel: channel, tickets: ticketsIn(channel))
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .refreshable { await apiVM.getAll() }
            .navigationTitle("Channels")
        }
    }
    
    func ticketsIn(_ channel: Channel) -> [Ticket] {
        return apiVM.tickets.filter({ $0.channelId == channel.id })
    }
    
    
    var outgoingChannels: [Channel] {
        let outgoing = apiVM.channels?.outgoing ?? []
        let peers = apiVM.peers?.connected ?? []
        
        var tempOutput: [Channel] = []
        for channel in outgoing {
            var temp = channel
            temp.peer = peers.first { $0.peerAddress == channel.peerAddress }
            tempOutput.append(temp)
        }
        
        var output: [Channel] = []
        if let aliases = apiVM.aliases {
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
        let outgoing = apiVM.channels?.incoming ?? []
        let peers = apiVM.peers?.connected ?? []
        
        var tempOutput: [Channel] = []
        for channel in outgoing {
            var temp = channel
            temp.peer = peers.first { $0.peerAddress == channel.peerAddress }
            tempOutput.append(temp)
        }
        
        var output: [Channel] = []
        if let aliases = apiVM.aliases {
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
        .environmentObject(APIVM())
}
