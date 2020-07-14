//
//  APIService.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation
import Alamofire

class APIService: APIServiceInterface {
    
    private let session: Session
    
    init(session: Session = .default) {
        self.session = session
    }
    
    func dataRequest(for request: Requestable, completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let urlRequest = try request.asURLRequest()
            self.session.request(urlRequest).responseData { dataResult in
                switch dataResult.result {
                case .success(let resultData):
                    completion(.success(resultData))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func request<T: Decodable>(for request: Requestable, completion: @escaping (Result<T, Error>) -> Void) {
        self.dataRequest(for: request) { result in
            switch result {
            case .success(let data):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decoded))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
