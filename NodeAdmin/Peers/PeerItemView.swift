//
//  PeersItem.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct PeerItemView: View {
    let peer: NodePeer
    var hasOutChannel: Bool = false
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.down.left.arrow.up.right")
                .bold()
                .symbolRenderingMode(.palette)
                .foregroundStyle(.grey.opacity(0.2), hasOutChannel ? .green:.grey.opacity(0.2))
            
            VStack(alignment: .leading) {
                Text(peer.displayName)
                    .foregroundStyle(.grey)
                    .fontWeight(.semibold)
                Text(peer.peerAddress)
                    .foregroundStyle(.grey.opacity(0.8))
                    .font(.custom("addresses", size: 8, relativeTo: .footnote))
            }
            Spacer()
            Image(systemName: "chevron.right")
        }
        .lightBluePanel
        .font(.footnote)
        .minimumScaleFactor(0.2)
        .lineLimit(1)
    }
    
    
}

#Preview(traits: .sizeThatFitsLayout) {
    PeerItemView(peer: NodePeer.preview, hasOutChannel: false)
}
