//
//  ChannelItemView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import SwiftUI

struct ChannelItemView: View {
    let channel: Channel
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: channel.direction)
                .foregroundStyle(channel.directionColor)
                .bold()
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("\(channel.directionPrefix) \(channel.displayName)")
                            .fontWeight(.semibold)
                        Text("id: \(channel.id)")
                            .lineLimit(1)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                HStack {
                    Spacer()
                    Text(channel.balance.valueWithUnit)
                        .font(.caption.weight(.semibold))
                }
            }
        }
        .lightBluePanel
        .font(.footnote)
        .minimumScaleFactor(0.2)
        .lineLimit(1)
    }
}


#Preview {
    ChannelItemView(channel: Channel.preview)
}
