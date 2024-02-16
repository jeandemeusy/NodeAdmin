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
                        HStack(spacing: 5) {
                            Text(channel.directionPrefix)
                            Text(channel.displayName)
                                .fontWeight(.semibold)
                        }
                        .font(.caption)
                        Text("id: \(channel.id)")
                            .minimumScaleFactor(0.2)
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
        .lineLimit(1)
        .minimumScaleFactor(0.2)
    }
}


#Preview {
    ChannelItemView(channel: Channel.preview)
}
