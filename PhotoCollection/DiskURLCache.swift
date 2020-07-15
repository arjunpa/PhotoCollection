//
//  DiskURLCache.swift
//  PhotoCollection
//
//  Created by Arjun P A on 14/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

final class DiskURLCache: URLCacheable {
    
    enum DiskCacheError: Error {
        case invalidRequest
        case noHTTPURLResponse
    }
    
    static let `default` = DiskURLCache(with: RequestURLCache.default)
    
    let urlCache: RequestURLCache
    
    private let concurrentQueue = DispatchQueue(label: "com.diskurlcache",
                                                attributes: [.concurrent])
    
    init(with urlCache: RequestURLCache) {
        self.urlCache = urlCache
    }
    
    func store<T: Decodable>(response: APIHTTPDecodableResponse<T>, forRequest request: Requestable, completion: URLCacheableStoreCompletion?) {
        self.concurrentQueue.async(flags: .barrier) { [weak self] in
            guard let urlRequest = try? request.asURLRequest(),
                  let methodRaw = urlRequest.httpMethod,
                  RequestMethod(rawValue: methodRaw) == .some(.get) else {
                    completion?(.failure(DiskCacheError.invalidRequest))
                    return
            }
            guard let httpResponse = response.httpResponse else {
                completion?(.failure(DiskCacheError.noHTTPURLResponse))
                return
            }
            self?.urlCache.storeCachedResponse(CachedURLResponse(response: httpResponse, data: response.data),
                                               for: urlRequest)
            completion?(.success(true))
        }
    }
    
    func get<T: Decodable>(forRequest request: Requestable, completion: @escaping (Result<APIHTTPDecodableResponse<T>?, Error>) -> Void) {
        self.concurrentQueue.async { [weak self] in
            guard let urlRequest = try? request.asURLRequest(),
                  let methodRaw = urlRequest.httpMethod,
                  RequestMethod(rawValue: methodRaw) == .some(.get) else {
                    completion(.failure(DiskCacheError.invalidRequest))
                    return
            }
            guard let cachedResponse = self?.urlCache.cachedResponse(for: urlRequest) else {
                completion(.success(nil))
                return
            }
            
            guard let httpURLResponse = cachedResponse.response as? HTTPURLResponse  else {
                completion(.failure(DiskCacheError.noHTTPURLResponse))
                return
            }
            do {
                let decoded = try cachedResponse.decoded(with: T.self)
                completion(.success(APIHTTPDecodableResponse(data: cachedResponse.data,
                                                             decoded: decoded,
                                                             httpResponse: httpURLResponse)))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
