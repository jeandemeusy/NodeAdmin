//
//  ChannelsStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import Alamofire

protocol ChannelsService {
    func GET_channels(for host: String, key: String, completion: @escaping (Result<Channels, Error>) -> ())
    func POST_channel(for host: String, key: String, address: String, amount: Double, completion: @escaping (Result<ChannelsPostChannel, Error>) -> ())
}

class ChannelsStore: ChannelsService {
    static let shared = ChannelsStore()
    
    func GET_channels(for host: String, key: String, completion: @escaping (Result<Channels, Error>) -> ()) {
        let url = buildURL(host: host, path: "channels")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: Channels.self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
        }
    }
    
    func POST_channel(for host: String, key: String, address: String, amount: Double, completion: @escaping (Result<ChannelsPostChannel, Error>) -> ()) {
        let url = buildURL(host: host, path: "channels")
        let headers = HTTPHeaders(["x-auth-token": key])
        let params: [String: Any] = ["peerAddress": address, "amount": "\(Int(amount*1e18))"]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ChannelsPostChannel.self) { response in
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

