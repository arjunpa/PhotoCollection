//
//  APIServiceError.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

enum APIServiceError: Error {
    
    enum URLFormableError: Error {
        case failed
    }
    
    enum CacheableRequestError: Error {
        case invalidMethod
    }
}
