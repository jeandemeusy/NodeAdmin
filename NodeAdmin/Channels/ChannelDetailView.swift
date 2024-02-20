//
//  ChannelDetailView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import SwiftUI

struct ChannelDetailView: View {
    let channel: Channel
    let tickets: [Ticket]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    DetailListItem(name: "With", content: channel.displayName)
                    DetailListItem(name: "ID", content: channel.id)
                }
                .lightBluePanel
                .vtop
            
                HStack {
                    DetailListItem(name: "Status", content: channel.status, contentColor: channel.statusColor)
                        .lightBluePanel
                    DetailListItem(name: "Balance", content: channel.balance.valueWithUnit)
                        .lightBluePanel
                }
                
                SectionTitle("Tickets")
                HStack {
                    DetailListItem(name: "Pending value", content: tickets.value.valueWithUnit, splitLines: true)
                        .lightBluePanel
                    DetailListItem(name: "Pending count", content: "\(tickets.count)", splitLines: true)
                        .lightBluePanel
                    
                }
                
                SectionTitle("Connectivity")
                HStack {
                    GreyButtonView(image: "custom.point.3.filled.connected.trianglepath.dotted.badge.plus", text: "Close channel") { }
                        .disabled(true)
                    GreyButtonView(image: "custom.point.3.filled.connected.trianglepath.dotted.badge.arrow.up", text: "Fund channel") { }
                        .disabled(true)

                }
                
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal)
            .navigationTitle(channel.directionPrefix + " " + channel.displayName)
        }
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    ChannelDetailView(channel: Channel.preview, tickets: [Ticket.preview])
}
