//
//  LightBlueTile.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/19/24.
//

import SwiftUI

struct LightBlueTile: View {
    var text: String
    var content: String
    
    init(text: String, value: Int?) {
        self.text = text
        if let value = value {
            self.content = String(value)
        } else {
            self.content = "-"
        }
    }
    
    init(text: String, value: Double?) {
        self.text = text
        if let value = value {
            self.content = String(value)
        } else {
            self.content = "-"
        }
    }
    
    init(text: String, content: String?) {
        self.text=text
        self.content = content ?? "-"
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(text)
                .font(.headline.weight(.bold))
                .foregroundStyle(.darkForegroundDM)
            
            Text(content)
                .font(.headline.weight(.medium))
                .lineLimit(1)
                .hright
                .foregroundStyle(.grey)
        }
        .monospaced()
        .lightBluePanel

    }
}

#Preview(traits: .sizeThatFitsLayout) {
    LightBlueTile(text: "HOPR", content: "0.1 wxHOPR")
}
