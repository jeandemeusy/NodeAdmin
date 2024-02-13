//
//  AliasesStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/12/24.
//

import Foundation
import Alamofire

protocol AliasesService {
    func GET_aliases(for host: String, key: String, completion: @escaping (Result<[String: String], Error>) -> ())
    func POST_alias(for host: String, key: String, peerId: String, alias: String, completion: @escaping (Result<Void, Error>) -> ())
    func DELETE_alias(for host: String, key: String, alias: String, completion: @escaping (Result<Void, Error>) -> ())
}

class AliasesStore: AliasesService {
    static let shared = AliasesStore()
    
    func GET_aliases(for host: String, key: String, completion: @escaping (Result<[String: String], Error>) -> ()) {
        let url = buildURL(host: host, path: "aliases")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [String: String].self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
        }
    }
    
    func POST_alias(for host: String, key: String, peerId: String, alias: String, completion: @escaping (Result<Void, Error>) -> ()) {
        let url = buildURL(host: host, path: "aliases")
        let headers = HTTPHeaders(["x-auth-token": key])
        let parameters: [String: Any] = ["peerId": peerId, "alias": alias]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func DELETE_alias(for host: String, key: String, alias: String, completion: @escaping (Result<Void, Error>) -> ()) {
        let url = buildURL(host: host, path: "aliases/\(alias)")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .delete, headers: headers).response { response in
            if let error = response.error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
}

