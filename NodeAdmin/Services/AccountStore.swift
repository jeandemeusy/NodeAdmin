//
//  AccountStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/10/24.
//

import Foundation
import Alamofire

protocol AccountService {
    func GET_addresses(for host: String, key: String, completion: @escaping (Result<AccountAddresses, Error>) -> ())
    func GET_balances(for host: String, key: String, completion: @escaping (Result<AccountBalances, Error>) -> ())
}

class AccountStore: AccountService {
    static let shared = AccountStore()
    
    func GET_addresses(for host: String, key: String, completion: @escaping (Result<AccountAddresses, Error>) -> ()) {
        let url = buildURL(host: host, path: "account/addresses")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: AccountAddresses.self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
        }
    }
    
    func GET_balances(for host: String, key: String, completion: @escaping (Result<AccountBalances, Error>) -> ()) {
        let url = buildURL(host: host, path: "account/balances")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: AccountBalances.self) { response in
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
