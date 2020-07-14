//
//  RequestEncoding.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation


import Foundation
import Alamofire

protocol RequestEncoding {
    func encode(_ request: URLRequest, with parameters: RequestParameters) throws -> URLRequest
}

struct GetRequestEncoding: RequestEncoding {
    
    func encode(_ request: URLRequest, with parameters: RequestParameters) throws -> URLRequest {
        return try URLEncoding().encode(request, with: parameters)
    }
}

struct PostRequestEncoding: RequestEncoding {
    
    func encode(_ request: URLRequest, with parameters: RequestParameters) throws -> URLRequest {
        return try JSONEncoding().encode(request, with: parameters)
    }
}
