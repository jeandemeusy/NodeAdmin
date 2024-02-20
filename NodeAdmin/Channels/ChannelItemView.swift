//
//  ChannelItemView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct ChannelItemView: View {
    let channel: Channel
    let tickets: [Ticket]
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: channel.directionImageName)
                .foregroundStyle(channel.status != "PendingToClose" ? channel.directionColor:.orange )
                .bold()
                .padding(1)
            
            VStack(alignment: .leading) {
                Text(channel.displayName)
                    .fontWeight(.semibold)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .hleft
                
                Text(channel.id)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                    .hright
                
                HStack {
                    Text(channel.balance.valueWithUnit)
                    Text("- \(tickets.value.valueWithUnit)")
                        .opacity(0.5)
                }
                .font(.caption2.weight(.semibold))
                .hright
            }
            
            Image(systemName: "chevron.right")

        }
        .lightBluePanel
        .font(.footnote)
    }
}


#Preview(traits: .sizeThatFitsLayout) {
    ChannelItemView(channel: Channel.preview, tickets: [Ticket.preview])
}
