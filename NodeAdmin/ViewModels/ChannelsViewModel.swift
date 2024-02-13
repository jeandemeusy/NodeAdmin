//
//  ChannelsViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

class ChannelsVM: ObservableObject {
    @Published var channels: Channels? = nil
    @Published var linkedAddresses: [String] = []
    
    func getAll(for host: String, key: String) {
        self.getChannels(for: host, key: key)
    }
    
    func getChannels(for host: String, key: String) {
        ChannelsStore.shared.GET_channels(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.channels = response
                self.linkedAddresses = response.outgoing.map({ $0.peerAddress })
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
}
