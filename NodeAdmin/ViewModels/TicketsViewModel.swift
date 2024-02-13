//
//  TicketsViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

class TicketsVM: ObservableObject {
    @Published var statistics: TicketsStatistics? = nil
    
    func host() -> String {
        return  UserDefaults.standard.string(forKey: "host") ?? ""
    }
    
    func key() -> String {
        return  UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getAll() {
        self.getStatistics()
    }
    
    func resetAll() {
        self.statistics = nil
    }
    
    func getStatistics() {
        TicketsStore.shared.GET_statistics(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.statistics = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
