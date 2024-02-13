//
//  NodeAdminApp.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

@main
struct NodeAdminApp: App {
    @StateObject var aliasesVM = AliasesVM()
    @StateObject var accountVM = AccountVM()
    @StateObject var channelsVM = ChannelsVM()
    @StateObject var nodeVM = NodeVM()
    @StateObject var ticketsVM = TicketsVM()
    
    @AppStorage("host") private var host = ""
    @AppStorage("token") private var token = ""
    
    init() {
        let largeMenuUifont = UIFont.monospacedSystemFont(ofSize: 36, weight: .bold)
        let smallMenuUifont = UIFont.monospacedSystemFont(ofSize: 18, weight: .bold)
        let tabUifont = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : largeMenuUifont,
            .foregroundColor: UIColor(.darkBlueHOPR),
        ]
        UINavigationBar.appearance().titleTextAttributes =  [
            .font : smallMenuUifont,
            .foregroundColor: UIColor(.darkBlueHOPR)
        ]
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: tabUifont
        ], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(aliasesVM)
                .environmentObject(accountVM)
                .environmentObject(channelsVM)
                .environmentObject(nodeVM)
                .environmentObject(ticketsVM)
                .onAppear {
                    aliasesVM.getAll()
                    accountVM.getAll()
                    channelsVM.getAll()
                    nodeVM.getAll()
                    ticketsVM.getAll()
                }
        }
        
    }
}
