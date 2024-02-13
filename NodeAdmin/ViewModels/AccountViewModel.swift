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
    
    func host() -> String {
        return  UserDefaults.standard.string(forKey: "host") ?? ""
    }
    
    func key() -> String {
        return  UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getAll() {
        self.getAddresses()
        self.getBalances()
    }
    
    func resetAll() {
        self.addresses = nil
        self.balances = nil
    }
    
    func getAddresses() {
        AccountStore.shared.GET_addresses(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.addresses = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getBalances() {
        AccountStore.shared.GET_balances(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.balances = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
