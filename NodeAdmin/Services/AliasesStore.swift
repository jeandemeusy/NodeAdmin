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
}

