//
//  PeerDetail.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI



struct PeerDetailView: View {
    @EnvironmentObject var apiVM: APIVM
    
    @State private var showAddAliasSheet = false
    @State private var showRemoveAliasSheet = false
    @State private var showOpenChannelSheet = false
    @State private var showSendMessageSheet = false
    
    @State private var newAlias: String = ""
    @State private var newAmount: Double = 0.0
    @State private var newMessage: String = ""
    @State private var newMessageWordCount: Int = 0

    let peer: NodePeer
    var hasOutChannel: Bool = false
    
    var body: some View {
        NavigationStack {
            GeometryReader { geo in
                ScrollView {
                    VStack {
                        DetailListItem(name: "ID", content: peer.peerId)
                        DetailListItem(name: "Address", content: peer.peerAddress)
                    }
                    .lightBluePanel
                    
                    DetailListItem(name: "Multi-address", content: peer.multiAddr)
                        .lightBluePanel
                    
                    HStack {
                        HStack {
                            DetailListItem(name: "Seen on", content: peer.lastSeen)
                        }
                        .lightBluePanel
                        DetailListItem(name: "Version", content: "v\(peer.version)")
                            .lightBluePanel
                            .frame(width: 2*geo.size.width/5)
                    }
                    
                    SectionTitle("Connectivity")
                    HStack {
                        GreyButtonView(image: "dot.radiowaves.up.forward", text: "Ping") {
                            apiVM.pingPeer(to: peer.peerId)
                        }
                        GreyButtonView(image: "custom.point.3.filled.connected.trianglepath.dotted.badge.plus", text: "Open channel") { showOpenChannelSheet = true }
                            .disabled(hasOutChannel)
                            
                    }
                    .padding(.horizontal)
                
                    SectionTitle("Aliases")
                    HStack {
                        GreyButtonView(image: "custom.person.text.rectangle.fill.badge.plus", text: "Add") { showAddAliasSheet.toggle() }
                            .disabled(peer.alias != nil)
                        GreyButtonView(image: "custom.person.text.rectangle.fill.badge.minus", text: "Remove") { showRemoveAliasSheet.toggle() }
                            .disabled(peer.alias == nil)
                    }
                    .padding(.horizontal)
                              
                    SectionTitle("Messages")
                    GreyButtonView(image: "envelope.fill", text: "Message", verticalOffset: -0.5) {
                        withAnimation(.easeInOut) {
                            showSendMessageSheet.toggle()
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .sheet(isPresented: $apiVM.pingResultFailed) {
                pingResultFailed
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $apiVM.pingResultAccessible) {
                pingResultSuccess
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showAddAliasSheet) {
                addAliasSheet
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showRemoveAliasSheet) {
                removeAliasSheet
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showOpenChannelSheet) {
                openChannelSheet
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showSendMessageSheet) {
                sendMessageSheet
                    .presentationDetents([.fraction(0.25), .medium])
                    .presentationDragIndicator(.visible)
            }
            .padding(.horizontal, 10)
            .navigationTitle((peer.alias != nil) ? peer.alias!:peer.peerId)
        }
    }
    
    var pingResultFailed: some View {
        SheetView(title: "Failed to ping") {
            Text("An error occured while pinging \(peer.displayName)")
                .lineLimit(2)
                .minimumScaleFactor(0.2)
                .multilineTextAlignment(.center)
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
    
    var sendMessageSheet: some View {
        SheetView(title: "Send message") {
            VStack {
                TextEditor(text: $newMessage)
                    .foregroundColor(.grey)
                    .font(.caption)
                    .monospaced()
                    .clipShape(.rect(cornerRadius: 10))
                
                Text("Word count: \(newMessageWordCount)")
                    .hright
                    .font(.footnote)
            }
            .onChange(of: newMessage) {
                let words = newMessage.split { $0 == " " || $0.isNewline }
                newMessageWordCount = words.count
            }
            
        } dismissAction: {
            newMessage = ""
            newMessageWordCount = 0
            showSendMessageSheet.toggle()
        } confirmAction: {
            apiVM.sendMessage(tag: 0, message: newMessage, to: peer.peerId)
            newMessage = ""
            newMessageWordCount = 0
            showSendMessageSheet.toggle()
        } disabledCondition: {
            false
        }

    }
}

#Preview("Without channel", traits: .sizeThatFitsLayout) {
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: false)
        .environmentObject(APIVM())
}
#Preview("With channel",  traits: .sizeThatFitsLayout) {    
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: true)
        .environmentObject(APIVM())
}
