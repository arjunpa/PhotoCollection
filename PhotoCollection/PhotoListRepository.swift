//
//  PhotoListRepository.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol PhotoListRepositoryInterface {
    func fetchPhotos(with completion: @escaping (Result<[Photo], Error>) -> Void)
}

final class PhotoListRepository: PhotoListRepositoryInterface {
    
    let apiService: APIServiceInterface
    
    let cache: URLCacheable
    
    init(apiService: APIServiceInterface, cache: URLCacheable) {
        self.apiService = apiService
        self.cache = cache
    }
    
    func fetchPhotos(with completion: @escaping (Result<[Photo], Error>) -> Void) {
        let cacheableRequest = CacheableRequest(request: Request(url: APIEndpoint.getPhotos,
                                                        method: .get,
                                                        parameters: nil,
                                                        headers: nil,
                                                        encoding: GetRequestEncoding()),
                                       expiry: .aged(43500))
        
        let responseClosure: (Result<APIHTTPDecodableResponse<[Photo]>, Error>) -> () = { [weak self] result in
            self?.handleResult(result, request: cacheableRequest, fromCache: false, completion: completion)
        }
        
        guard self.apiService.isReachable else {
            self.cache.get(forRequest: cacheableRequest) { [weak self] (result: Result<APIHTTPDecodableResponse<[Photo]>?, Error>) in
                switch result {
                case .success(let response):
                    guard let response = response else {
                        self?.apiService.request(for: cacheableRequest.request, completion: responseClosure)
                        return
                    }
                    self?.handleResult(.success(response), request: cacheableRequest, fromCache: true, completion: completion)
                case .failure(let error):
                    self?.handleResult(.failure(error), request: cacheableRequest, fromCache: false, completion: completion)
                }
            }
            return
        }
        self.apiService.request(for: cacheableRequest.request, completion: responseClosure)
    }
    
    private func handleResult(_ result: Result<APIHTTPDecodableResponse<[Photo]>, Error>,
                              request: CacheableRequest,
                              fromCache: Bool,
                              completion: @escaping (Result<[Photo], Error>) -> Void) {
        switch result {
        case .success(let response):
            DispatchQueue.main.async {
                completion(.success(response.decoded))
            }
            guard !fromCache else { return }
            self.cache.store(response: response, forRequest: request, completion: nil)
        case .failure(let error):
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
    }
}
