//
//  Settings.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var aliasesVM: AliasesVM
    @EnvironmentObject var accountVM: AccountVM
    @EnvironmentObject var channelsVM: ChannelsVM
    @EnvironmentObject var nodeVM: NodeVM
    @EnvironmentObject var ticketsVM: TicketsVM
    
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Credentials"), footer: Text("Restart the app to apply modifications")) {
                    HStack {
                        Label("Host", systemImage: "server.rack")
                        TextField("host:port", text: $host)
                            .multilineTextAlignment(.trailing)
                    }

                    HStack {
                        Label("Token", systemImage: "key.horizontal")
                        SecureField("token", text: $token)
                            .textContentType(.password)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            .monospaced()
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
