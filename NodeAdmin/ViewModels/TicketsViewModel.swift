//
//  TicketsViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

class TicketsVM: ObservableObject {
    @Published var statistics: TicketsStatistics? = nil
    
    func getAll(for host: String, key: String) { }
    
    func getStatistics(for host: String, key: String) {
        TicketsStore.shared.GET_statistics(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.statistics = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
