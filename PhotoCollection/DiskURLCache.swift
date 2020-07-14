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
    
    func store(response: CachedURLResponse, forRequest request: Requestable, completion: URLCacheableStoreCompletion?) {
        self.concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let urlRequest = try? request.asURLRequest(),
                  let methodRaw = urlRequest.httpMethod,
                  RequestMethod(rawValue: methodRaw) == .some(.get) else {
                    completion?(false)
                    return
            }
            self?.urlCache.storeCachedResponse(response, for: urlRequest)
            completion?(true)
        }
    }
    
    func get(forRequest request: Requestable, completion: @escaping URLCacheableGetCompletion) {
        self.concurrentQueue.async { [weak self] in
            guard let urlRequest = try? request.asURLRequest(),
                  let methodRaw = urlRequest.httpMethod,
                  RequestMethod(rawValue: methodRaw) == .some(.get) else {
                    completion(nil)
                    return
            }
            completion(self?.urlCache.cachedResponse(for: urlRequest))
        }
    }
}
