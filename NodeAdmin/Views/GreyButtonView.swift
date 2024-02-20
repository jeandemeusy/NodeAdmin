//
//  PeerButton.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/19/24.
//

import SwiftUI


struct GreyButtonView: View {
    let image: String
    var text: String
    var verticalOffset: Double = 0.0
    var action: (() -> Void)? = nil
    
    var body: some View {
        Button {
            if let action = action {
                action()
            }
        } label: {
            VStack(spacing:2) {
                Image(safeName: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 14)
                    .offset(x: 0, y: verticalOffset)
                
                Text(text)
            }
            .hcenter
        }
        .buttonStyle(.hopr)
        .frame(maxHeight: 50)
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    GreyButtonView(image: "calendar", text: "Calendar")
}
