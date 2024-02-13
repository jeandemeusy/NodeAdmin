//
//  Settings.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Credentials")) {
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
