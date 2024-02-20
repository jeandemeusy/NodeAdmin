//
//  Settings.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var apiVM: APIVM
    
    @State private var showAddAccountSheet: Bool = false
    @State private var showRemoveAccountSheet: Bool = false
    @State private var newNodeNickname: String = ""
    @State private var newNodeHost: String = ""
    @State private var newNodeToken: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Credentials")) {
                    if let credentials = credentials {
                        Picker("Account", selection: $apiVM.credential) {
                            Text(" - ").tag(nil as SavedAccount?)
                            ForEach(credentials, id: \.self) { credential in
                                Text(credential.nickname)
                                    .tag(Optional(credential))
                            }
                        }
                        .onChange(of: apiVM.credential) {
                            apiVM.resetAll()
                            Task {
                                await apiVM.getAll()
                            }
                        }
                    }
                    
                    Button {
                        showAddAccountSheet.toggle()
                    } label: {
                        Text("Add account")
                    }
                    .buttonStyle(.automatic)
                    .tint(.green)
                
                    if (credentials?.count ?? 0) > 0 {
                        Button {
                            showRemoveAccountSheet.toggle()
                        } label: {
                            Text("Remove account")
                        }
                        .buttonStyle(.automatic)
                        .tint(.red)
                    }
                }
                .sheet(isPresented: $showAddAccountSheet) {
                    addAccountSheet
                        .presentationDetents([.fraction(0.35)])
                        .presentationDragIndicator(.visible)
                }
                .sheet(isPresented: $showRemoveAccountSheet) {
                    removeAccountSheet
                        .presentationDetents([.fraction(0.25)])
                        .presentationDragIndicator(.visible)
                }
            }
            .monospaced()
            .navigationTitle("Settings")
        }
    }
    
    var credentials: [SavedAccount]? {
        let items = apiVM.getCredentials()
        
        if (items.count == 0) {
            return nil
        }
        
        return items
    }
    
    var addAccountSheet: some View {
        SheetView(title: "Add acount") {
            VStack {
                HStack {
                    Text("Nickname")
                        .fontWeight(.semibold)
                    TextField("Alice", text: $newNodeNickname)
                        .foregroundStyle(Color.primary)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("Host")
                        .fontWeight(.semibold)
                    TextField("http://ip:port", text: $newNodeHost)
                        .foregroundStyle(Color.primary)
                        .textFieldStyle(.roundedBorder)
                }
                HStack {
                    Text("API token")
                        .fontWeight(.semibold)
                    TextField("^MyAP1T0ken^", text: $newNodeToken)
                        .foregroundStyle(Color.primary)
                        .textFieldStyle(.roundedBorder)
                }
            }
        } dismissAction: {
            resetNewAccountVars()
        } confirmAction: {
            _ = apiVM.addCredentialsEntry(for: newNodeNickname, host: newNodeHost, key: newNodeToken)
            resetNewAccountVars()
        } disabledCondition: {
            newNodeNickname.isEmpty || newNodeHost.isEmpty || newNodeToken.isEmpty
        }
    }
    
    var removeAccountSheet: some View {
        SheetView(title: "Remove account") {
            Text("Are you sure you want to delete '\(apiVM.nickname)' account ?")
                .font(.caption)
                .multilineTextAlignment(.center)
        } dismissAction: {
            showRemoveAccountSheet.toggle()
        } confirmAction: {
            _ = apiVM.removeCurrentCredentialsEntry()
            showRemoveAccountSheet.toggle()
        }
    }
    
    func resetNewAccountVars() {
        showAddAccountSheet = false
        newNodeNickname = ""
        newNodeHost = ""
        newNodeToken = ""
    }
}

#Preview {
    SettingsView()
        .environmentObject(APIVM())
}
