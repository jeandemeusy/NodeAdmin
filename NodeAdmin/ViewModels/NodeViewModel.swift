//
//  NodeViewModel.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation


class NodeVM: ObservableObject {
    @Published var version: NodeVersion? = nil
    @Published var peers: NodePeers? = nil
    @Published var info: NodeInfo? = nil
    
    @Published var pingResult: PeersPing? = nil
    @Published var pingResultAccessible: Bool = false
    @Published var pingResultFailed: Bool = false
    
    func host() -> String {
        return  UserDefaults.standard.string(forKey: "host") ?? ""
    }
    
    func key() -> String {
        return  UserDefaults.standard.string(forKey: "token") ?? ""
    }
    
    func getAll() {
        self.getPeers()
        self.getVersion()
        self.getInfo()
    }
    
    func resetAll() {
        self.version = nil
        self.peers = nil
        self.info = nil
        self.pingResult = nil
        self.pingResultAccessible = false
        self.pingResultFailed = false
    }
    
    func getVersion() {
        NodeStore.shared.GET_version(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.version = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getPeers() {
        NodeStore.shared.GET_peers(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.peers = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getInfo() {
        NodeStore.shared.GET_info(for: host(), key: key()) { result in
            switch result {
            case .success(let response):
                self.info = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func pingPeer(to: String) {
        PeersStore.shared.POST_ping(for: host(), key: key(), to: to) { result in
            switch result {
            case .success(let response):
                self.pingResult = response
                self.pingResultAccessible.toggle()
            case .failure(let error):
                debugPrint(error)
                self.pingResultFailed.toggle()
            }
        }
    }
}

