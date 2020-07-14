//
//  DiskURLCache.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class DiskURLCache: URLCacheable {
    
    let urlCache: RequestURLCache
    
    private let concurrentQueue = DispatchQueue(label: "com.diskurlcache",
                                                attributes: [.concurrent])
    
    init(with urlCache: RequestURLCache) {
        self.urlCache = urlCache
    }
    
    func store(response: CachedURLResponse, forRequest request: URLRequest, completion: URLCacheableStoreCompletion?) {
        self.concurrentQueue.async(flags: .barrier) { [weak self] in
            self?.urlCache.storeCachedResponse(response, for: request)
            completion?(true)
        }
    }
    
    func get(forRequest request: URLRequest, completion: @escaping URLCacheableGetCompletion) {
        self.concurrentQueue.async { [weak self] in
            completion(self?.urlCache.cachedResponse(for: request))
        }
    }
}
