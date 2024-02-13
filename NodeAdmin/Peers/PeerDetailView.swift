//
//  PeerDetail.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct PeerActionButton: View {
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
            .frame(width: 140, height: 14)
            .padding()
                
        }
        .background(LinearGradient(colors: [
            .brightBlueHOPR,
            .darkBlueHOPR
        ], startPoint: .leading, endPoint: .trailing))
        .foregroundStyle(.white)
        .clipShape(.rect(cornerSize: CGSize(width: 16, height: 16)))
    }
}

struct PeerDetailView: View {
    @StateObject var nodeVM = NodeVM()
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""

    let peer: NodePeer
    
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
                
                HStack {
                    PeerActionButton(image: "dot.radiowaves.up.forward", text: "Ping") {
                        nodeVM.pingPeer(for: host, key: token, to: peer.peerId)
                    }
                    PeerActionButton(image: "custom.person.text.rectangle.fill.badge.plus", text: "Add alias", verticalOffset: 1.5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.gray.opacity(0.8))
                        }
                }
                .padding(.top)
                HStack {
                    PeerActionButton(image: "point.3.filled.connected.trianglepath.dotted", text: "Open channel", verticalOffset: -1)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.gray.opacity(0.8))
                        }
                    PeerActionButton(image: "envelope.fill", text: "Message", verticalOffset: -0.5)
                        .overlay {
                            RoundedRectangle(cornerRadius: 16)
                                .foregroundStyle(.gray.opacity(0.8))
                        }
                }
                .alert(isPresented: $nodeVM.pingResultFailed) {
                    Alert(title: Text("Error"),
                          message: Text("Pinging failed"),
                          dismissButton: .default(
                            Text("Ok"), action: { nodeVM.pingResultFailed.toggle() }))
                }
            }
            .alert(isPresented: $nodeVM.pingResultAccessible) {
                Alert(title: Text("Ping successful"),
                      message: Text("latency: \(nodeVM.pingResult!.latency) ms"),
                      dismissButton: .default(
                        Text("Ok"), action: { nodeVM.pingResultAccessible.toggle() }))
            }
            .padding(.horizontal, 10)
            .navigationTitle((peer.alias != nil) ? peer.alias!:peer.peerId)
        }
    }
}

#Preview {
    PeerDetailView(peer: NodePeer.preview)
}
