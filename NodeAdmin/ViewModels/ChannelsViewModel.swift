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
    
    func host() -> String {
        return  UserDefaults.standard.string(forKey: "host") ?? ""
    }
    
    func key() -> String {
        return  UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getAll() {
        self.getChannels()
    }
    
    func resetAll() {
        self.channels = nil
        self.linkedAddresses = []
    }
    
    func getChannels() {
        ChannelsStore.shared.GET_channels(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.channels = response
                self.linkedAddresses = response.outgoing.map({ $0.peerAddress })
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func postChannel(address: String, amount: Double) {
        ChannelsStore.shared.POST_channel(for: host(), key: key(), address: address, amount: amount) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }

    }
    
    
}
