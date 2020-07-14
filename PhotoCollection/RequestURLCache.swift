//
//  RequestURLCache.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class RequestURLCache: URLCache {
    
    private static let expiryDateKey = "expiryDate"
    
    private static let shouldExpireKey = "shouldExpire"
    
    static let `default` = RequestURLCache(memoryCapacity: 10 * 1024 * 1024,
                                           diskCapacity: 25 * 1024 * 1024,
                                           diskPath: nil)
    
    /// The cache expiry in seconds.
    let defaultCacheExpiry: TimeInterval
    
    init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?, expiry: TimeInterval) {
        self.defaultCacheExpiry = expiry
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    override init(memoryCapacity: Int, diskCapacity: Int, diskPath path: String?) {
        self.defaultCacheExpiry = 43500
        super.init(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: path)
    }
    
    override func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        let cachedResponse = super.cachedResponse(for: request)
        guard let shouldExpire = cachedResponse?.userInfo?[type(of: self).shouldExpireKey] as? Bool else {
            return nil
        }
        guard shouldExpire else { return cachedResponse }
        if let expiryDate = cachedResponse?.userInfo?[type(of: self).expiryDateKey] as? Date {
            if expiryDate.timeIntervalSinceNow < -self.defaultCacheExpiry {
                self.removeCachedResponse(for: request)
            } else {
                return cachedResponse
            }
        }
        return nil
    }
    
    override func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {

        let selfType = type(of: self)
        
        let shouldExpire = cachedResponse.userInfo?[selfType.shouldExpireKey] as? Bool ?? true
        
        var userInfo = cachedResponse.userInfo ?? [:]
        userInfo[selfType.shouldExpireKey] = shouldExpire
        
        if shouldExpire {
            userInfo[selfType.expiryDateKey] = Date()
        }
        super.storeCachedResponse(CachedURLResponse(response: cachedResponse.response,
                                                    data: cachedResponse.data,
                                                    userInfo: userInfo,
                                                    storagePolicy: cachedResponse.storagePolicy),
                                  for: request)
    }
}
