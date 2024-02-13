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
}

