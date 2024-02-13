//
//  AliasesViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation

class AliasesVM: ObservableObject {
    @Published var aliases: [String: String]? = nil
    
    func host() -> String {
        return  UserDefaults.standard.string(forKey: "host") ?? ""
    }
    
    func key() -> String {
        return  UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getAll() {
        self.getAliases()
    }
    
    func resetAll() {
        self.aliases = nil
    }
    
    func getAliases() {
        AliasesStore.shared.GET_aliases(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.aliases = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func postAlias(peerId: String, alias: String) {
        AliasesStore.shared.POST_alias(for: host(), key: key(), peerId: peerId, alias: alias) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func deleteAlias(alias: String) {
        AliasesStore.shared.DELETE_alias(for: host(), key: key(), alias: alias) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }}
