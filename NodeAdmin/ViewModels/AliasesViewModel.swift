//
//  AliasesViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation

class AliasesVM: ObservableObject {
    @Published var aliases: [String: String]? = nil
    
    func getAll(for host: String, key: String) {
        self.getAliases(for: host, key: key)
    }
    
    func getAliases(for host: String, key: String) {
        AliasesStore.shared.GET_aliases(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.aliases = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
