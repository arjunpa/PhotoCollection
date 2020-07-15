//
//  URLCacheable.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

typealias URLCacheableStoreCompletion = (Result<Bool, Error>) -> ()

protocol URLCacheable {
    func store<T: Decodable>(response: APIHTTPDecodableResponse<T>, forRequest request: Requestable, completion: URLCacheableStoreCompletion?)
    func get<T: Decodable>(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>?, Error>) -> Void)
}
