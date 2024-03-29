//
//  NodeAdminApp.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

@main
struct NodeAdminApp: App {
    @StateObject var apiVM = APIVM()
    
    init() {
        let largeMenuUifont = UIFont.monospacedSystemFont(ofSize: 36, weight: .bold)
        let smallMenuUifont = UIFont.monospacedSystemFont(ofSize: 18, weight: .bold)
        let tabUifont = UIFont.monospacedSystemFont(ofSize: 12, weight: .regular)

        UINavigationBar.appearance().largeTitleTextAttributes = [
            .font : largeMenuUifont,
            .foregroundColor: UIColor(.darkForegroundDM),
        ]
        UINavigationBar.appearance().titleTextAttributes =  [
            .font : smallMenuUifont,
            .foregroundColor: UIColor(.darkForegroundDM)
        ]
        UITabBarItem.appearance().setTitleTextAttributes([
            .font: tabUifont
        ], for: .normal)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(apiVM)
                .onAppear {
                    Task {
                        await apiVM.getAll()
                    }
                    apiVM.assignCredential()
                }
        }
    }
}
