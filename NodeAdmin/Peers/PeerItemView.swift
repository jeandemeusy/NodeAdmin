//
//  PeersItem.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct PeerItemView: View {
    let peer: NodePeer
    let hasOutChannel: Bool
    
    var body: some View {
        HStack {
            Image(systemName: "arrow.down.left.arrow.up.right")
                .bold()
                .symbolRenderingMode(.palette)
                .foregroundStyle(Color(white:0.2).opacity(0.2), hasOutChannel ? .green:Color(white: 0.2).opacity(0.2))
            
            VStack(alignment: .leading) {
                Text(peer.displayName)
                    .foregroundStyle(Color(white: 0.2))
                    .fontWeight(.semibold)
                Text(peer.peerAddress)
                    .foregroundStyle(.secondary)
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

#Preview {
    PeerItemView(peer: NodePeer.preview, hasOutChannel: false)
}
