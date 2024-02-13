//
//  NodeStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import Alamofire


protocol NodeService {
    func GET_version(for host: String, key: String, completion: @escaping (Result<NodeVersion, Error>) -> ())
    func GET_peers(for host: String, key: String, completion: @escaping (Result<NodePeers, Error>) -> ())
    func GET_info(for host: String, key: String, completion: @escaping (Result<NodeInfo, Error>) -> ())

}

class NodeStore: NodeService {
    static let shared = NodeStore()

    func GET_version(for host: String, key: String, completion: @escaping (Result<NodeVersion, Error>) -> ()) {
        let url = buildURL(host: host, path: "node/version")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: String.self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(NodeVersion(version: result)))
        }
    }
    
    func GET_peers(for host: String, key: String, completion: @escaping (Result<NodePeers, Error>) -> ()) {
        let url = buildURL(host: host, path: "node/peers")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NodePeers.self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
       }
    }
    
    func GET_info(for host: String, key: String, completion: @escaping (Result<NodeInfo, Error>) -> ()) {
        let url = buildURL(host: host, path: "node/info")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: NodeInfo.self) { response in
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
