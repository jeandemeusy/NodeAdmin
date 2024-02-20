//
//  SectionTitle.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/19/24.
//

import SwiftUI

struct SectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }
    
    var body: some View {
        Text(title)
            .monospaced()
            .font(.caption)
            .foregroundStyle(.darkForegroundSecondaryDM)
            .padding(.top)
            .hleft
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    SectionTitle("Safe's balance")
}
