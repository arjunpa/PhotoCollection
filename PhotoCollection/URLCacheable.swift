//
//  URLCacheable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias URLCacheableStoreCompletion = (Bool) -> ()
typealias URLCacheableGetCompletion = (CachedURLResponse?) -> ()

protocol URLCacheable {
    func store(response: CachedURLResponse, forRequest request: URLRequest, completion: URLCacheableStoreCompletion?)
    func get(forRequest request: URLRequest, completion: @escaping URLCacheableGetCompletion)
}
