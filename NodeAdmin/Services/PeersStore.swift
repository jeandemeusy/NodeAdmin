//
//  PeersStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation
import Alamofire

protocol PeersService {
    func POST_ping(for host: String, key: String, to: String, completion: @escaping (Result<PeersPing, Error>) -> ())
}

class PeersStore: PeersService {
    static let shared = PeersStore()
    
    func POST_ping(for host: String, key: String, to: String, completion: @escaping (Result<PeersPing, Error>) -> ()) {
        let url = buildURL(host: host, path: "peers/\(to)/ping")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .post, headers: headers).responseDecodable(of: PeersPing.self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
        }
    }
}
