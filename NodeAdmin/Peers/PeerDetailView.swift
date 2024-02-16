//
//  PeerDetail.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

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
        .foregroundStyle(.grey)
    }
}

struct PeerActionButton: View {
    let image: String
    var text: String
    var rotationDegrees: Double = 0.0
    var verticalOffset: Double = 0.0
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            HStack {
                Spacer()
                VStack(spacing:2) {
                    ZStack {
                        Image(systemName: image)
                        Image(image)
                    }
                    .rotationEffect(.degrees(rotationDegrees))
                    .offset(x: 0, y: verticalOffset)
                    
                    Text(text)
                }
                Spacer()
            }
        }
        .buttonStyle(.hopr)
    }
}

struct PeerDetailView: View {
    @EnvironmentObject var apiVM: APIVM
    
    @State private var showAddAliasSheet = false
    @State private var showRemoveAliasSheet = false
    @State private var showOpenChannelSheet = false
    @State private var newAlias: String = ""
    @State private var newAmount: Double = 0.0

    let peer: NodePeer
    var hasOutChannel: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    ListItem(name: "ID", content: peer.peerId)
                    ListItem(name: "Address", content: peer.peerAddress)
                }
                .lightBluePanel
                
                ListItem(name: "Multi-address", content: peer.multiAddr)
                    .lightBluePanel
                
                HStack {
                    HStack {
                        ListItem(name: "Seen on", content: peer.lastSeen)
                    }
                    .lightBluePanel
                    ListItem(name: "Version", content: "v\(peer.version)")
                        .lightBluePanel
                }
                
                SectionTitle("Connectivity")
                HStack {
                    PeerActionButton(image: "dot.radiowaves.up.forward", text: "Ping"      ) {
                        apiVM.pingPeer(to: peer.peerId)
                    }
                    PeerActionButton(image: "point.3.filled.connected.trianglepath.dotted", text: "Open channel", verticalOffset: -1) { showOpenChannelSheet = true }
                        .disabled(hasOutChannel)
                        
                }
                .padding(.horizontal)
            
                SectionTitle("Aliases")
                HStack {
                    PeerActionButton(image: "custom.person.text.rectangle.fill.badge.plus", text: "Add", verticalOffset: 1.5) { showAddAliasSheet.toggle() }
                        .disabled(peer.alias != nil)
                    PeerActionButton(image: "custom.person.text.rectangle.fill.badge.minus", text: "Remove", verticalOffset: 1.5) { showRemoveAliasSheet.toggle() }
                        .disabled(peer.alias == nil)
                }
                .padding(.horizontal)
                          
                SectionTitle("Messages")
                PeerActionButton(image: "envelope.fill", text: "Message", verticalOffset: -0.5)
                    .disabled(true)
                    .padding(.horizontal)
            }
            .sheet(isPresented: $apiVM.pingResultFailed) {
                pingResultFailed
                    .presentationDetents([.height(200), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $apiVM.pingResultAccessible) {
                pingResultSuccess
                    .presentationDetents([.height(200), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showAddAliasSheet) {
                addAliasSheet
                    .presentationDetents([.height(200), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showRemoveAliasSheet) {
                removeAliasSheet
                    .presentationDetents([.height(200), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showOpenChannelSheet) {
                openChannelSheet
                    .presentationDetents([.height(200), .medium])
                    .presentationDragIndicator(.visible)
            }
            .padding(.horizontal, 10)
            .navigationTitle((peer.alias != nil) ? peer.alias!:peer.peerId)
        }
    }
    
    var pingResultFailed: some View {
        SheetView(title: "Failed to ping") {
            EmptyView()
        }
    }
    
    var pingResultSuccess: some View {
        SheetView(title: "Ping successful") {
            Text("latency: \(apiVM.pingResult!.latency) ms")
                .vcenter
        }
    }
    
    var addAliasSheet: some View {
        SheetView(title: "Add alias", footer: "After submission, a delay of ~30s is to expect before the alias is visible") {
            HStack {
                Text("Alias")
                    .fontWeight(.semibold)
                TextField("Alice", text: $newAlias)
                    .foregroundStyle(Color.primary)
                    .textFieldStyle(.roundedBorder)
            }
            .frame(width: 300)
        } dismissAction: {
            showAddAliasSheet = false
            newAlias = ""
        } confirmAction: {
            apiVM.postAlias(peerId: peer.peerId, alias: newAlias)
            showAddAliasSheet = false
            newAlias = ""
        } disabledCondition: {
            newAlias.isEmpty
        }
    }
    
    var removeAliasSheet: some View {
        SheetView(title: "Remove alias", footer: "After submission, a delay of ~30s is to expect before the alias is removed") {
            EmptyView()
        } dismissAction: {
            showRemoveAliasSheet = false
        } confirmAction: {
            apiVM.deleteAlias(alias: peer.alias!)
            showRemoveAliasSheet = false
        }
    }
    
    var openChannelSheet: some View {
        SheetView(title: "Open channel", footer: "After submission, a delay of ~30s is to expect before the channel is opened") {
            HStack {
                Text("Amount")
                    .fontWeight(.semibold)
                TextField("Amount", value: $newAmount, format: .number)
                    .textFieldStyle(.roundedBorder)
                    .foregroundStyle(Color.primary)
                Text("wxHOPR")
            }
            .frame(width: 300)
        } dismissAction: {
            showOpenChannelSheet = false
            newAmount = 0.0
        } confirmAction: {
            apiVM.postChannel(address: peer.peerAddress, amount: newAmount)
            showOpenChannelSheet = false
            newAmount = 0.0
        } disabledCondition: {
            newAmount == 0
        }
    }
}

#Preview("Without channel") {
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: false)
        .environmentObject(APIVM())
}
#Preview("With channel") {    
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: true)
        .environmentObject(APIVM())
}
