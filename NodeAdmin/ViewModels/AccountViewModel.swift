//
//  AccountViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import Foundation

class AccountVM: ObservableObject {
    @Published var addresses: AccountAddresses? = nil
    @Published var balances: AccountBalances? = nil
    
    func getAll(for host: String, key: String) {
        self.getAddresses(for: host, key: key)
        self.getBalances(for: host, key: key)
    }
    
    func getAddresses(for host: String, key: String) {
        AccountStore.shared.GET_addresses(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.addresses = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getBalances(for host: String, key: String) {
        AccountStore.shared.GET_balances(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.balances = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
