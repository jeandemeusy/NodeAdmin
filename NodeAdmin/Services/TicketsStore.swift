//
//  TicketsStore.swift
//  NodeAdmin
//
//  Created by Jean Demeusy on 2/11/24.
//

import Foundation
import Alamofire

protocol TicketsService {
    func GET_tickets(for host: String, key: String,  completion: @escaping (Result<[Ticket], Error>) -> ())
    func GET_statistics(for host: String, key: String, completion: @escaping (Result<TicketsStatistics, Error>) -> ())
}

class TicketsStore: TicketsService {
    static let shared = TicketsStore()
    
    func GET_tickets(for host: String, key: String,  completion: @escaping (Result<[Ticket], Error>) -> ()) {
        let url = buildURL(host: host, path: "tickets")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: [Ticket].self) { response in
            guard let result = response.value else {
                if let error = response.error {
                    completion(.failure(error))
                }
                return
            }
            completion(.success(result))
        }
    }
    
    func GET_statistics(for host: String, key: String, completion: @escaping (Result<TicketsStatistics, Error>) -> ()) {
        let url = buildURL(host: host, path: "tickets/statistics")
        let headers = HTTPHeaders(["x-auth-token": key])
        
        AF.request(url, method: .get, headers: headers).responseDecodable(of: TicketsStatistics.self) { response in
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
