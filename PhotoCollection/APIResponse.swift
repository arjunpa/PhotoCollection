//
//  APIResponse.swift
//  PhotoCollection
//
//  Created by Arjun P A on 15/07/20.
//  Copyright © 2020 Arjun P A. All rights reserved.
//

import Foundation

struct APIHTTPDataResponse {
    let data: Data
    let httpResponse: HTTPURLResponse?
}

struct APIHTTPDecodableResponse<T> where T:Decodable {
    let data: Data
    let decoded: T
    let httpResponse: HTTPURLResponse?
}
