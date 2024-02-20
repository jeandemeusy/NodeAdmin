//
//  MessageStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/19/24.
//

import Foundation
import Alamofire

protocol MessagesService {
    func POST_message(for host: String, key: String, tag: Int, message: String, to: String, completion: @escaping (Result<String, Error>) -> ())
}

class MessagesStore: MessagesService {
    static let shared = MessagesStore()
    
    func POST_message(for host: String, key: String, tag: Int, message: String, to: String, completion: @escaping (Result<String, Error>) -> ()) {
        let url = buildURL(host: host, path: "messages")
        let headers = HTTPHeaders(["x-auth-token": key])
        let params: [String: Any] = ["tag": tag, "body": message, "peerId": to, "path": []]
        
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: String.self) { response in
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
