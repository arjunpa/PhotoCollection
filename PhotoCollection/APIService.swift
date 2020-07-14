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
    
    let session: Session
    
    let reachabilityManager: NetworkReachabilityManager?
    
    var isReachable: Bool {
        return self.reachabilityManager?.isReachable ?? false
    }
    
    init(session: Session = .default, reachabilityManager: NetworkReachabilityManager? = NetworkReachabilityManager.default) {
        self.session = session
        self.reachabilityManager = reachabilityManager
    }
    
    func dataRequest(for request: Requestable, completion: @escaping (Result<APIHTTPResponse<Data>, Error>) -> Void) {
        do {
            let urlRequest = try request.asURLRequest()
            self.session.request(urlRequest).responseData { dataResult in
                switch dataResult.result {
                case .success(let resultData):
                    completion(.success(APIHTTPResponse<Data>(dataResult: resultData, httpResponse: dataResult.response)))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func request<T: Decodable>(for request: Requestable, completion: @escaping (Result<APIHTTPResponse<T>, Error>) -> Void) {
        self.dataRequest(for: request) { result in
            switch result {
            case .success(let apiResult):
                do {
                    let decoded = try JSONDecoder().decode(T.self, from: apiResult.dataResult)
                    completion(.success(APIHTTPResponse<T>(dataResult: decoded, httpResponse: apiResult.httpResponse)))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
