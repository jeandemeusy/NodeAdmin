//
//  ListItem.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import SwiftUI

struct DetailListItem: View {
    var name: String
    var content: String?
    var contentColor: Color = .grey
    var splitLines: Bool = false
    
    var body: some View {
        Group {
            if splitLines {
                VStack {
                    Text(name)
                        .fontWeight(.semibold)
                        .hleft
                    
                    Text(content ?? "-")
                        .foregroundStyle(contentColor)
                        .minimumScaleFactor(0.25)
                        .hright
                }
            } else {
                HStack {
                    Text(name)
                        .fontWeight(.semibold)
                    Spacer()
                    Text(content ?? "-")
                        .foregroundStyle(contentColor)
                        .minimumScaleFactor(0.25)
                }
            }
        }
        .font(.footnote)
        .foregroundStyle(.grey)
        .monospaced()
        .lineLimit(1)

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    DetailListItem(name: "Item in list", content: "Detail")
}
