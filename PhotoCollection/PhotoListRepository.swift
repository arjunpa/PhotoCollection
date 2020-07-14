//
//  PhotoListRepository.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

protocol PhotoListRepositoryInterface {
    func fetchPhotos(with completion: (Result<[Photo], Error>) -> Void)
}

final class PhotoListRepository: PhotoListRepositoryInterface {
    
    let apiService: APIServiceInterface
    
    let cache: URLCacheable
    
    init(apiService: APIServiceInterface, cache: URLCacheable) {
        self.apiService = apiService
        self.cache = cache
    }
    
    func fetchPhotos(with completion: (Result<[Photo], Error>) -> Void) {
        guard self.apiService.isReachable else {
            
        }
    }
    
    private func fetchPhotosFromRemote(with completion: (Result<[Photo], Error>) -> Void) {
        self.apiService.request(for: <#T##Requestable#>, completion: <#T##(Result<APIHTTPResponse<Decodable>, Error>) -> Void#>)
    }
}
