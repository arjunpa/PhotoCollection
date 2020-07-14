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
        let request = Request(url: APIEndpoint.getPhotos,
                              method: .get,
                              parameters: nil,
                              headers: nil,
                              encoding: GetRequestEncoding())
        guard self.apiService.isReachable else {
            self.cache.get(forRequest: request) { cachedResponse in
                guard let cachedResponse = cachedResponse,
                      let decoded = try? cachedResponse.decoded(with: [Photo].self) else {
                        self.fetchPhotosFromRemote(with: request, completion: completion)
                        return
                }
                completion(.success(decoded))
            }
            return
        }
        self.fetchPhotosFromRemote(with: request, completion: completion)
    }
    
    private func fetchPhotosFromRemote(with request: Requestable, completion: @escaping (Result<[Photo], Error>) -> Void) {
        
        self.apiService.request(for: request) { (result: Result<APIHTTPDecodableResponse<[Photo]>, Error>) in
                                                switch result {
                                                case .success(let response):
                                                    completion(.success(response.decoded))
                                                    guard let httpResponse = response.httpResponse else { return }
                                                    self.cache.store(response: CachedURLResponse(response: httpResponse,
                                                                                                 data: response.data),
                                                                     forRequest: request,
                                                                     completion: nil)
                                                case .failure(let error):
                                                    completion(.failure(error))
                                                }
        }
    }
}
