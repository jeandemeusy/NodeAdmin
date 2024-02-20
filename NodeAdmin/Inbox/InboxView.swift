//
//  InboxView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/20/24.
//

import SwiftUI

struct InboxView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Hello, World !")
            }
            .monospaced()
            .navigationTitle("Inbox")
        }
    }
}

#Preview {
    InboxView()
}
