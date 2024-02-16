//
//  APIVM.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation

class APIVM: ObservableObject {
    @Published var aliases: [String: String]? = nil
    
    @Published var addresses: AccountAddresses? = nil
    @Published var balances: AccountBalances? = nil
    
    @Published var channels: Channels? = nil
    @Published var linkedAddresses: [String] = []
    
    @Published var version: NodeVersion? = nil
    @Published var peers: NodePeers? = nil
    @Published var info: NodeInfo? = nil
    
    @Published var pingResult: PeersPing? = nil
    @Published var pingResultAccessible: Bool = false
    @Published var pingResultFailed: Bool = false
    
    @Published var statistics: TicketsStatistics? = nil
    
    @Published var credential: SavedAccount? = nil
    
    var nickname: String { credential?.nickname ?? "" }
    var host: String { credential?.host ?? "" }
    var key: String { credential?.token ?? "" }
    
    func getCredentials() -> [SavedAccount] {
        if let savedData = UserDefaults.standard.object(forKey: "credentials") as? Data {
            do {
                 return try JSONDecoder().decode([SavedAccount].self, from: savedData)
            } catch {
                // Failed to convert Data to SavedAccount
            }
        }
        return []
    }
    
    func addCredentialsEntry(for nickname: String, host: String, key: String) -> Bool {
        var credentials = getCredentials()
        let newCredential = SavedAccount(nickname: nickname, host: host, token: key)
        credentials.append(newCredential)
        
        do {
            let encodedData = try JSONEncoder().encode(credentials)
            UserDefaults.standard.set(encodedData, forKey: "credentials")
            self.credential = newCredential
            return true
        }
        catch {
            // Failed to encode SavedAccount to Data
        }
        return false
    }
    
    func removeCredentialsEntry(for nickname: String, host: String, key: String) -> Bool {
        return false
    }
    
    func resetAll() {
        self.aliases = nil
        self.addresses = nil
        self.balances = nil
        self.channels = nil
        self.linkedAddresses = []
        self.version = nil
        self.peers = nil
        self.info = nil
        self.pingResult = nil
        self.statistics = nil
    }
    
    func getAll() async {
        self.getAliases()
        self.getAddresses()
        self.getBalances()
        self.getChannels()
        self.getVersion()
        self.getInfo()
        self.getPeers()
        self.getStatistics()
    }
    
    func assignCredential() {
        if (credential == nil) {
            credential = getCredentials().first
        }
    }

//   █████  ██      ██  █████  ███████ ███████ ███████
//  ██   ██ ██      ██ ██   ██ ██      ██      ██
//  ███████ ██      ██ ███████ ███████ █████   ███████
//  ██   ██ ██      ██ ██   ██      ██ ██           ██
//  ██   ██ ███████ ██ ██   ██ ███████ ███████ ███████
    
    func getAliases() {
        AliasesStore.shared.GET_aliases(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.aliases = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func postAlias(peerId: String, alias: String) {
        AliasesStore.shared.POST_alias(for: host, key: key, peerId: peerId, alias: alias) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func deleteAlias(alias: String) {
        AliasesStore.shared.DELETE_alias(for: host, key: key, alias: alias) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }

//   █████   ██████  ██████  ██████  ██    ██ ███    ██ ████████
//  ██   ██ ██      ██      ██    ██ ██    ██ ████   ██    ██
//  ███████ ██      ██      ██    ██ ██    ██ ██ ██  ██    ██
//  ██   ██ ██      ██      ██    ██ ██    ██ ██  ██ ██    ██
//  ██   ██  ██████  ██████  ██████   ██████  ██   ████    ██
    
    func getAddresses() {
        AccountStore.shared.GET_addresses(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.addresses = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getBalances() {
        AccountStore.shared.GET_balances(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.balances = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
//   ██████ ██   ██  █████  ███    ██ ███    ██ ███████ ██      ███████
//  ██      ██   ██ ██   ██ ████   ██ ████   ██ ██      ██      ██
//  ██      ███████ ███████ ██ ██  ██ ██ ██  ██ █████   ██      ███████
//  ██      ██   ██ ██   ██ ██  ██ ██ ██  ██ ██ ██      ██           ██
//   ██████ ██   ██ ██   ██ ██   ████ ██   ████ ███████ ███████ ███████
    
    func getChannels() {
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
    
    func postChannel(address: String, amount: Double) {
        ChannelsStore.shared.POST_channel(for: host, key: key, address: address, amount: amount) { result in
            switch result {
            case .success:
                break
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    //  ███    ██  ██████  ██████  ███████
    //  ████   ██ ██    ██ ██   ██ ██
    //  ██ ██  ██ ██    ██ ██   ██ █████
    //  ██  ██ ██ ██    ██ ██   ██ ██
    //  ██   ████  ██████  ██████  ███████
    
    func getVersion() {
        NodeStore.shared.GET_version(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.version = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getPeers() {
        NodeStore.shared.GET_peers(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.peers = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func getInfo() {
        NodeStore.shared.GET_info(for: host, key: key) { result in
            switch result {
            case .success(let response):
                self.info = response
            case .failure(let error):
                debugPrint(error)
            }
        }
    }
    
    func pingPeer(to: String) {
        PeersStore.shared.POST_ping(for: host, key: key, to: to) { result in
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
    
//  ████████ ██  ██████ ██   ██ ███████ ████████ ███████
//     ██    ██ ██      ██  ██  ██         ██    ██
//     ██    ██ ██      █████   █████      ██    ███████
//     ██    ██ ██      ██  ██  ██         ██         ██
//     ██    ██  ██████ ██   ██ ███████    ██    ███████
    
    func getStatistics() {
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
