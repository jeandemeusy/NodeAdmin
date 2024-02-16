//
//  Peers.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct PeersView: View {
    @EnvironmentObject var apiVM: APIVM

    
    @State private var searchText = ""
    @State private var showAliasesSheet: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing:4) {
                    HStack {
                        LightBlueTile(text: "Connected", value: apiVM.peers?.numConnected)
                        LightBlueTile(text: "Announced", value: apiVM.peers?.numAnnounced)
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
            .toolbar {
                Button {
                    showAliasesSheet.toggle()
                } label : {
                    Text("Aliases")
                }
            }
        }
        .refreshable { await apiVM.getAll() }
        
        .sheet(isPresented: $showAliasesSheet) {
            aliasesSheet
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .searchable(text: $searchText, prompt: "Search by alias, peerId, or address")
        .textInputAutocapitalization(.never)
    }
    
    var aliasesSheet: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Aliases")
                    .font(.headline)
                if let aliases = apiVM.aliases {
                    ScrollView {
                        ForEach(aliases.sorted(by: <), id: \.key) { alias, peerId in
                            VStack(alignment: .leading) {
                                Text(alias)
                                    .fontWeight(.semibold)
                                HStack {
                                    Spacer()
                                    Text(peerId)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.2)
                                }
                            }
                            .lightBluePanel
                        }
                    }
                    .scrollIndicators(.never)
                    .font(.footnote)
                }
//                Spacer()
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding([.top, .horizontal])
            .monospaced()
        }
    }
    
    var peersWithChannels: [NodePeer] {
        var filtered: [NodePeer] = []
        if let peers = apiVM.peers {
            filtered = peers.connected.filter {
                apiVM.linkedAddresses.contains($0.peerAddress)
            }
        }
                
        var output: [NodePeer] = []
        /// keys and values are inverted (it's alias -> peer_id)
        if let aliases = apiVM.aliases {
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
        if let peers = apiVM.peers {
            filtered = peers.connected.filter { !apiVM.linkedAddresses.contains($0.peerAddress) }
        }
        
        var output: [NodePeer] = []
        if let aliases = apiVM.aliases {
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
        .environmentObject(APIVM())
}
