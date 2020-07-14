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
        guard self.apiService.isReachable else {
            return
        }
        self.fetchPhotosFromRemote(with: completion)
    }
    
    private func fetchPhotosFromRemote(with completion: @escaping (Result<[Photo], Error>) -> Void) {
        let request = Request(url: APIEndpoint.getPhotos,
                              method: .get,
                              parameters: nil,
                              headers: nil,
                              encoding: GetRequestEncoding())
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
