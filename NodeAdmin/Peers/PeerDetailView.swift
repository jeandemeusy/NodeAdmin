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
    @Environment(\.isEnabled) private var isEnabled: Bool

    let image: String
    var text: String? = nil
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
                    
                    if let text=text {
                        Text(text)
                            .font(.footnote.weight(.semibold))
                            .monospaced()
                    }
                }
                Spacer()
            }
            .frame(height: 14)
            .padding()
        }
        .foregroundStyle(isEnabled ? .white:.gray)
        .background(.gradientHOPR.opacity(isEnabled ? 1:0))
        .clipShape(
            .capsule(style: .continuous)
        )
        .overlay {
            Capsule()
                .stroke(.gray, lineWidth: 1)
                .opacity(isEnabled ? 0:1)
        }
    }
}

struct PeerDetailView: View {
    @EnvironmentObject var aliasesVM: AliasesVM
    @EnvironmentObject var channelsVM: ChannelsVM
    @EnvironmentObject var nodeVM: NodeVM
    
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
                        nodeVM.pingPeer(to: peer.peerId)
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
            .sheet(isPresented: $nodeVM.pingResultFailed) {
                pingResultFailed
                    .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $nodeVM.pingResultAccessible) {
                pingResultSuccess
                    .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $showAddAliasSheet) {
                addAliasSheet
                    .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $showRemoveAliasSheet) {
                removeAliasSheet
                    .presentationDetents([.height(200)])
            }
            .sheet(isPresented: $showOpenChannelSheet) {
                openChannelSheet
                    .presentationDetents([.height(200)])
            }
            .padding(.horizontal, 10)
            .navigationTitle((peer.alias != nil) ? peer.alias!:peer.peerId)
        }
    }
    
    var pingResultFailed: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Pinging failed")
                    .font(.headline)
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding(.horizontal)
            .monospaced()
        }
    }
    
    var pingResultSuccess: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Ping successful")
                    .font(.headline)
                Text("latency: \(nodeVM.pingResult!.latency) ms")
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding(.horizontal)
            .monospaced()
        }
    }
    
    var addAliasSheet: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Add alias")
                    .font(.headline)
                HStack {
                    Text("Alias")
                        .fontWeight(.semibold)
                    TextField("Alice", text: $newAlias)
                        .foregroundStyle(Color.primary)
                        .textFieldStyle(.roundedBorder)
                }
                    .frame(width: 300)
                
                Divider()
                    .padding(.bottom)
                
                HStack {
                    Button {
                        showAddAliasSheet = false
                        newAlias = ""
                    } label: {
                        Text("Dismiss")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .overlay {
                                Capsule()
                                    .stroke(.red, lineWidth: 1)
                            }
                    }
                    Spacer()
                    
                    Button {
                        aliasesVM.postAlias(peerId: peer.peerId, alias: newAlias)
                        showAddAliasSheet = false
                        newAlias = ""
                    } label: {
                        Text("Submit")
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(.gradientHOPR)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    .disabled(newAlias.isEmpty)
                }
                .padding(.bottom)
                Text("After submission, a delay of ~30s is to expect before the alias is visible")
                    .multilineTextAlignment(.center)
                    .font(.custom("note", size: 10, relativeTo: .footnote))
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding(.horizontal, 25)
            .monospaced()
        }
    }
    
    var removeAliasSheet: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Remove alias")
                    .font(.headline)
                
                Divider()
                    .padding(.bottom)
                
                HStack {
                    Button {
                        showRemoveAliasSheet = false
                    } label: {
                        Text("Dismiss")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .overlay {
                                Capsule()
                                    .stroke(.red, lineWidth: 1)
                            }
                    }
                    Spacer()
                    
                    Button {
                        aliasesVM.deleteAlias(alias: peer.alias!)
                        showRemoveAliasSheet = false
                    } label: {
                        Text("Confirm")
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(.gradientHOPR)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                }
                .padding(.bottom)
                Text("After submission, a delay of ~30s is to expect before the alias is removed")
                    .multilineTextAlignment(.center)
                    .font(.custom("note", size: 10, relativeTo: .footnote))
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding(.horizontal, 25)
            .monospaced()
        }
    }
    
    var openChannelSheet: some View {
        ZStack {
            Color.yellowHOPR.ignoresSafeArea(.all)
            VStack {
                Text("Open channel")
                    .font(.headline)
                HStack {
                    Text("Amount")
                        .fontWeight(.semibold)
                    TextField("Amount", value: $newAmount, format: .number)
                        .textFieldStyle(.roundedBorder)
                        .foregroundStyle(Color.primary)
                    Text("wxHOPR")
                }
                    .frame(width: 300)
                
                Divider()
                    .padding(.bottom)
                
                HStack {
                    Button {
                        showOpenChannelSheet = false
                        newAmount = 0.0
                    } label: {
                        Text("Dismiss")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.red)
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .overlay {
                                Capsule()
                                    .stroke(.red, lineWidth: 1)
                            }
                    }
                    Spacer()
                    
                    Button {
                        channelsVM.postChannel(address: peer.peerAddress, amount: newAmount)
                        showOpenChannelSheet = false
                        newAmount = 0.0
                    } label: {
                        Text("Submit")
                            .font(.footnote.weight(.semibold))
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                            .background(.gradientHOPR)
                            .foregroundStyle(.white)
                            .clipShape(.capsule)
                    }
                    .disabled(newAmount == 0)
                }
                .padding(.bottom)
                Text("After submission, a delay of ~30s is to expect before the channel is opened")
                    .multilineTextAlignment(.center)
                    .font(.custom("note", size: 10, relativeTo: .footnote))
            }
            .foregroundStyle(._darkBlueHOPR)
            .padding(.horizontal, 25)
            .monospaced()
        }
    }
}

#Preview("Without channel") {
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: false)
        .environmentObject(AliasesVM())
        .environmentObject(ChannelsVM())
        .environmentObject(NodeVM())
}
#Preview("With channel") {    
    PeerDetailView(peer: NodePeer.preview, hasOutChannel: true)
        .environmentObject(AliasesVM())
        .environmentObject(ChannelsVM())
        .environmentObject(NodeVM())

}
