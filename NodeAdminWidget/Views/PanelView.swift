//
//  PanelView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import SwiftUI


struct PanelView: View {
    let line1: String
    let line2: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(line1)
                .bold()
            
            Text(line2)
                .minimumScaleFactor(0.9)
                .lineLimit(1)
                .fontWeight(.semibold)
                .hright
        }
        .font(.caption)
        .monospaced()
        .padding(5)
        .foregroundStyle(._darkBlueHOPR)
        .background(.lightgrey)
        .clipShape(.rect(cornerRadius: 10))

    }
}

#Preview {
    PanelView(line1: "First line", line2: "Second line")
}
