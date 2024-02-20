//
//  ContentView.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var apiVM: APIVM
    
    @State var selection = 0
    var body: some View {
        TabView(selection: $selection) {
            HomeView()
                .tabItem { Label("Home", systemImage: "house")}
                .tag(0)
            
            PeersView()
                .tabItem { Label("Peers", systemImage: "person.2.wave.2.fill")}
                .tag(1)
            
//            InboxView()
//                .tabItem { Label("Inbox", systemImage: "tray.full.fill")}
//                .tag(2)
            
            ChannelsView()
                .tabItem { Label("Channels", systemImage: "arrow.triangle.swap")}
                .tag(3)
            
            SettingsView()
                .tabItem { Label("Settings", systemImage: "gear") }
                .tag(4)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(APIVM())
}


