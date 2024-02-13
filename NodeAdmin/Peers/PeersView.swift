//
//  Peers.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct PeersView: View {
    @EnvironmentObject var aliasesVM: AliasesVM
    @EnvironmentObject var channelsVM: ChannelsVM
    @EnvironmentObject var nodeVM: NodeVM
    
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing:4) {
                    HStack {
                        LightBlueTile(text: "Connected", value: nodeVM.peers?.numConnected)
                        LightBlueTile(text: "Announced", value: nodeVM.peers?.numAnnounced)
                    }

                    SectionTitle("With outgoing channel")
                    ForEach(peersWithChannels, id: \.peerId) { peer in
                        NavigationLink {
                            PeerDetailView(peer: peer, hasOutChannel: true)
                        } label: {
                            PeerItemView(peer: peer, hasOutChannel: true)
                        }
                    }
                    
                    SectionTitle("Others")
                    ForEach(peersWithoutChannels, id: \.peerId) { peer in
                        NavigationLink {
                            PeerDetailView(peer: peer)
                        } label: {
                            PeerItemView(peer: peer)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .navigationTitle("Peers")
        }
        .refreshable { await reload() }
        .searchable(text: $searchText, prompt: "Search by alias, peerId, or address")
        .textInputAutocapitalization(.never)
    }
    
    func reload() async {
        aliasesVM.getAll()
        channelsVM.getAll()
        nodeVM.getAll()
    }
    
    var peersWithChannels: [NodePeer] {
        var filtered: [NodePeer] = []
        if let peers = nodeVM.peers {
            filtered = peers.connected.filter {
                channelsVM.linkedAddresses.contains($0.peerAddress)
            }
        }
                
        var output: [NodePeer] = []
        /// keys and values are inverted (it's alias -> peer_id)
        if let aliases = aliasesVM.aliases {
            for peer in filtered {
                var temp = peer
                temp.alias = aliases.key(for: peer.peerId)
                output.append(temp)
            }
        }
        
        if !searchText.isEmpty {
            output = output.filter { peer in
                (peer.alias != nil && peer.alias!.localizedCaseInsensitiveContains(searchText)) ||
                 peer.peerId.localizedCaseInsensitiveContains(searchText) ||
                 peer.peerAddress.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return output.sorted { $0.displayName < $1.displayName }
    }
    
    var peersWithoutChannels: [NodePeer] {
        var filtered: [NodePeer] = []
        if let peers = nodeVM.peers {
            filtered = peers.connected.filter { !channelsVM.linkedAddresses.contains($0.peerAddress) }
        }
        
        var output: [NodePeer] = []
        if let aliases = aliasesVM.aliases {
            for peer in filtered {
                var temp = peer
                temp.alias = aliases.key(for: peer.peerId)
                output.append(temp)
            }
        }
        
        if !searchText.isEmpty {
            output = output.filter { peer in
                (peer.alias != nil && peer.alias!.localizedCaseInsensitiveContains(searchText)) ||
                 peer.peerId.localizedCaseInsensitiveContains(searchText) ||
                 peer.peerAddress.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return output.sorted { $0.displayName < $1.displayName }
    }
}

#Preview {
    PeersView()
        .environmentObject(AliasesVM())
        .environmentObject(ChannelsVM())
        .environmentObject(NodeVM())
}
